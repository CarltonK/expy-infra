# Enable Cloud Run API
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

# Enable Secret Manager API
resource "google_project_service" "secretmanager" {
  provider = google-beta
  service  = "secretmanager.googleapis.com"
}

# Secret Manager
resource "google_secret_manager_secret" "database_user" {
  provider = google-beta

  secret_id = "database_user"

  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "database_user_version" {
  provider    = google-beta
  secret      = google_secret_manager_secret.database_user.id
  secret_data = var.database_user
}

resource "google_secret_manager_secret" "database_password" {
  secret_id = "database_password"

  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "database_password_version" {
  provider    = google-beta
  secret      = google_secret_manager_secret.database_password.id
  secret_data = var.database_password
}

# Cloud SQL
resource "google_sql_database_instance" "instance" {
  name                = "${var.project_name}-${var.workspace_env}-db"
  region              = var.location_id
  database_version    = "POSTGRES_11"
  deletion_protection = "false"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "${var.project_name}-${var.workspace_env}-db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "database-user" {
  name     = var.database_user
  instance = google_sql_database_instance.instance.name
  password = var.database_password
}

# Cloud Run
resource "google_cloud_run_service" "expy-dev" {
  name     = "${var.project_name}-${var.workspace_env}"
  location = var.location_id

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/${var.project_name}-${var.workspace_env}:latest"
        ports {
          container_port = 8080
        }
        env {
          name  = "NODE_ENV"
          value = var.workspace_env
        }
      }

      service_account_name = "${var.project_name}-${var.workspace_env}-591@${var.project_id}.iam.gserviceaccount.com"
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run]
}

resource "google_cloud_run_service_iam_member" "allUsers" {
  service  = google_cloud_run_service.expy-dev.name
  location = google_cloud_run_service.expy-dev.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Cloud Build
resource "google_cloudbuild_trigger" "build-trigger" {
  name = "${var.workspace_env}-cloud-run-builder"
  tags = [ var.workspace_env ]

  github {
    owner = "CarltonK"
    name  = "expense_manager"
    push {
      branch = "develop"
    }
  }

  substitutions = {
    _CONNECTION_NAME = google_sql_database_instance.instance.connection_name
    _DATABASE_URL    = "postgres://${var.database_user}:${var.database_password}@localhost/${google_sql_database_instance.instance.name}?host=/cloudsql/${google_sql_database_instance.instance.connection_name}"
    _PROJECT_REGION  = var.location_id
    _PROJECT_SERVICE = "${var.project_name}-${var.workspace_env}"
  }

  filename = "cloudbuild/${var.workspace_env}.yaml"
}
