resource "google_container_cluster" "gcp_k8s" {
  name                     = "gcp-k8s"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network_name
  subnetwork               = var.google_compute_subnet
  networking_mode          = "VPC_NATIVE"
  deletion_protection      = false
  ip_allocation_policy {
  }
  node_locations = [
    "europe-west1-c",
    "europe-west1-d"
  ]
  node_config {
    disk_size_gb = 25
  }
  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  release_channel {
    channel = "REGULAR"
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.vm_subnet2_cidr
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.168.0.0/28"
  }
}


resource "google_container_node_pool" "general" {
  name       = "gcp-np"
  cluster    = google_container_cluster.gcp_k8s.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible     = true
    machine_type    = "e2-medium"
    disk_size_gb    = 25
    image_type      = "ubuntu_containerd"
    service_account = var.K8S_email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }


}
