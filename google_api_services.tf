# Enable Cloud Run API
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

# Enable Secret Manager API
resource "google_project_service" "secretmanager" {
  provider = google-beta
  service  = "secretmanager.googleapis.com"
}