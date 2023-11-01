variable "project_id" {
  type        = string
  description = "final-project-iti-hendawyy"
}

variable "region" {
  type        = string
  description = "europe-west1"
}

variable "zone" {
  type        = string
  description = "europe-west1-b"
}

variable "sa-key" {
  type        = string
  description = "../Secrets/final-project-iti-hendawyy-85436efc3b09.json"
}

variable "region2" {
  type    = string
  default = "us-east1"
}
variable "zone2" {
  type    = string
  default = "us-east1-b"
}

variable "rolezzz" {
  type = list(string)
  default = [
    "roles/source.reader",
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    "roles/container.clusterAdmin",
    "roles/container.admin",
  # "projects/final-project-iti-hendawyy/roles/CustomRolecont"
  ]
}
