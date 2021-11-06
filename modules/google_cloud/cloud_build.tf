# Cloud Build
resource "google_cloudbuild_trigger" "build-trigger" {
  name = "${var.workspace_env}-cloud-run-builder"
  tags = [var.workspace_env]

  github {
    owner = var.github_user
    name  = var.github_repo
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
