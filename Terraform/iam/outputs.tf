output "sa_1_email" {
  description = "Email of sa_1"
  value       = google_service_account.sa_1.email
}

output "K8S_email" {
  description = "Email of K8S"
  value       = google_service_account.K8S.email
}

output "sa_1_key" {
  value = google_service_account_key.sa_1_key
}
