terraform {
  backend "gcs" {
    bucket = "<EXPY_PROJECT_ID>-tfstate"
    prefix = "env/dev"
  }
}
