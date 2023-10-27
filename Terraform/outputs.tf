output "private_vm_ip" {
  value = module.compute.private_vm_ip
}
output "sa_1_email" {
  value = module.IAM.sa_1_email
}

output "K8S_email" {
  value = module.IAM.K8S_email
}
