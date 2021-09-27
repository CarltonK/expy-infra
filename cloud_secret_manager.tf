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