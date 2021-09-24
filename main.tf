# Terraform Configs
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.83.0"
    }
  }
  # backend "remote" {
  #   organization = var.org_name

  #   workspaces {
  #     name = var.workspace_id
  #   }
  # }
}

provider "google" {
  # Needed for CI pipeline
  credentials = file("CREDENTIALS_FILE.json")
  project     = var.project_id
  region      = var.location_id
  zone        = var.zone_id
}

provider "google-beta" {
  project = var.project_id
  credentials = file("CREDENTIALS_FILE.json")
}
