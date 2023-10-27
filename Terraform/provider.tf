provider "google" {
  credentials = file(var.sa-key)
  # credentials = jsondecode(var.sa-key)


  project = var.project_id
  region  = var.region
  zone    = var.zone
}
