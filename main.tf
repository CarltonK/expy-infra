provider "google" {
  credentials = file("CREDENTIALS_FILE.json")
  project     = "nijenge"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}
