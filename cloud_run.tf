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
        env {
          name = "ACCESS_TOKEN"
          value = var.database_password
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
