resource "google_compute_instance" "private_vm" {
  name         = "private-vm-instance"
  machine_type = "e2-medium"
  zone         = var.zone2


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.google_compute_subnet2
  }

  metadata = {
    "sa-1-key" = var.sa_1_key.private_key
  }

  metadata_startup_script = file(var.startup_script)

  tags = ["iap-allow-ssh"]
}
