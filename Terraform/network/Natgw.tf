resource "google_compute_router" "nat-router" {
  name    = "nat-router"
  network = google_compute_network.gcp-iti-network.self_link
  region  = var.region2
}

resource "google_compute_router_nat" "nat-config" {
  name                               = "nat-gateway"
  router                             = google_compute_router.nat-router.name
  region                             = var.region2
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet2.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
