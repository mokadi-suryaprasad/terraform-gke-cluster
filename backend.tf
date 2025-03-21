terraform {
  backend "gcs" {
    bucket      = "terraform-state-dev-surya"
    prefix      = "terraform/gke"
  }
}
