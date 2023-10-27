resource "google_compute_firewall" "allow-iap-ssh" {
  name          = "allow-iap-ssh"
  network       = google_compute_network.gcp-iti-network.name
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["iap-allow-ssh"]
}
