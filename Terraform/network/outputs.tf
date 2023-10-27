output "network_name" {
  description = "Name of the network"
  value       = google_compute_network.gcp-iti-network.name
}

output "google_compute_subnet" {
  value = google_compute_subnetwork.subnet1.name
}

output "google_compute_subnet2" {
  value = google_compute_subnetwork.subnet2.name
}

output "vm_subnet2_cidr" {
  value = google_compute_subnetwork.subnet2.ip_cidr_range
}
