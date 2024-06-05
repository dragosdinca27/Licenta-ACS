module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "1.6.0"

  project_id = var.project_id
  names      = ["gitlab-docker-registry-cache"]
  prefix     = local.resource_prefix

  storage_class   = "REGIONAL"
  location        = var.region
  set_admin_roles = true

  versioning = {
    services = true
  }
}
