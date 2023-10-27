output "private_vm_ip" {
  description = "Internal IP address of the private VM"
  value       = google_compute_instance.private_vm.network_interface.0.network_ip
}
