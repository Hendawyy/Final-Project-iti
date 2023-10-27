# Artifact Registry
resource "google_artifact_registry_repository" "my_repository" {
  repository_id = "my-images"
  format        = "DOCKER"
  location      = var.region2
  
}
