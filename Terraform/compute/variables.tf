variable "project_id" {
  type    = string
  default = "final-project-iti-hendawyy"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "sa-key" {
  type    = string
  default = "../Secrets/final-project-iti-hendawyy-85436efc3b09.json"
}

variable "network_name" {
  type = string
}
variable "region2" {
  type    = string
  default = "us-east1"
}

variable "zone2" {
  type    = string
  default = "us-east1-b"
}

variable "startup_script" {
  default = "../Scripts/Startupscript.sh"
}

variable "google_compute_subnet" {}
variable "google_compute_subnet2" {}
variable "sa_1_email" {}
variable "K8S_email" {}
variable "sa_1_key" {}
variable "vm_subnet2_cidr" {}
variable "sa_1-email" {}
