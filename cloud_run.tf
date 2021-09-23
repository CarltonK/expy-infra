# Enable Cloud Run API
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

# Cloud SQL
resource "google_sql_database_instance" "instance" {
  name   = "expy-db"
  region = var.location_id
  database_version = "POSTGRES_11"
  deletion_protection = "false"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "expy-db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "database-user" {
  name     = var.database_user
  instance = google_sql_database_instance.instance.name
  password = var.database_password
}

# Cloud Run
resource "google_cloud_run_service" "expy-dev" {
  name     = "expy-dev"
  location = var.location_id

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/expy-dev:latest"
        ports {
          container_port = 8080
        }
      }
      # TODO: Use TF
      service_account_name = "expy-dev-591@expy-317620.iam.gserviceaccount.com"
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
resource "google_cloudbuild_trigger" "dev-cloud-run-builder" {
  trigger_template {
    branch_name = "develop"
    repo_name   = "expense_manager"
  }

  substitutions = {
    _CONNECTION_NAME = google_sql_database_instance.instance.connection_name
    _DATABASE_URL = "postgres://${var.database_user}:${var.database_password}@localhost/${google_sql_database_instance.instance.name}?host=/cloudsql/${google_sql_database_instance.instance.connection_name}"
    _PROJECT_REGION = var.location_id
    _PROJECT_SERVICE = "expy-dev"
  }

  filename = "cloudbuild/dev.yaml"
}