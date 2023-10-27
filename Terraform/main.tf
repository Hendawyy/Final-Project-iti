module "network" {
  source     = "./network"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  sa-key     = var.sa-key
  region2    = var.region2
}

module "compute" {
  source                 = "./compute"
  project_id             = var.project_id
  region                 = var.region
  zone                   = var.zone
  region2                = var.region2
  sa-key                 = var.sa-key
  network_name           = module.network.network_name
  google_compute_subnet  = module.network.google_compute_subnet
  google_compute_subnet2 = module.network.google_compute_subnet2
  sa_1_email             = module.IAM.sa_1_email
  K8S_email              = module.IAM.K8S_email
  sa_1_key               = module.IAM.sa_1_key
  vm_subnet2_cidr        = module.network.vm_subnet2_cidr
}

module "IAM" {
  source     = "./iam"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  sa-key     = var.sa-key

}

module "storage" {
  source     = "./storage"
  zone       = var.zone
  sa-key     = var.sa-key
  project_id = var.project_id
  region     = var.region
}
