provider "google" {
  version = "3.32.0"
  credentials = file("terraform-sa.json")
  project = var.project_id
  region  = var.region
  zone    = "${var.region}-c"
}
