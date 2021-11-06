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
