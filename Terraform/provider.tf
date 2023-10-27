provider "google" {
  credentials = file(var.sa-key)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
