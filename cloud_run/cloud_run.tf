# Enable Cloud Run API
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

resource "google_cloud_run_service" "hello-service" {
  name = "hello-service"
  location = var.location_id

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
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
  service  = google_cloud_run_service.hello-service.name
  location = google_cloud_run_service.hello-service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}