provider "google" {
  project = var.project_id
  region  = var.location_id
  zone    = var.zone_id
}

provider "google-beta" {
  project = var.project_id
  region  = var.location_id
  zone    = var.zone_id
}

module "google_cloud" {
  source            = "../../modules/google_cloud"
  project_id        = var.project_id
  location_id       = var.location_id
  zone_id           = var.zone_id
  database_user     = var.database_user
  database_password = var.database_password
  project_name      = var.project_name
  workspace_env     = var.workspace_env
  github_user       = var.github_user
  github_repo       = var.github_repo
}
