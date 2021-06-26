provider "google" {
  credentials = file("CREDENTIALS_FILE.json")
  project     = "expy-317620"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}


# Terraform Backend
terraform {
  backend "remote" {
    organization = "kweli-smart"

    workspaces {
      name = "expy-infra"
    }
  }
}
