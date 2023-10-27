# resource "google_project_service" "compute" {
#   service = "compute.googleapis.com"
# }

# resource "google_project_service" "container" {
#   service = "container.googleapis.com"
# }

# resource "google_project_service" "enable_cloud_resource_manager_api" {
#   service                    = "cloudresourcemanager.googleapis.com"
#   disable_dependent_services = true
# }

resource "google_compute_network" "gcp-iti-network" {
  name                            = "gcp-iti-network"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "subnet1" {
  name                     = "subnet1"
  region                   = var.region
  network                  = google_compute_network.gcp-iti-network.id
  ip_cidr_range            = "10.0.1.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet2" {
  name                     = "subnet2"
  region                   = var.region2
  network                  = google_compute_network.gcp-iti-network.id
  ip_cidr_range            = "10.0.2.0/24"
  private_ip_google_access = true
}
