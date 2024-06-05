locals {
  subnet_prefix = "${var.project_base_name}-${var.project_environment}-subnet"
  subnet_cicd   = "${local.subnet_prefix}-cicd-01"
}

module "gitlab-cicd-vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.4"
  project_id   = var.project_id
  network_name = "${local.resource_prefix}-cicd-vpc"

  subnets = [
    {
      subnet_name           = local.subnet_cicd
      subnet_ip             = "10.11.12.0/24"
      subnet_private_access = false
      subnet_region         = var.region
    }
  ]
}

resource "google_compute_firewall" "personal-ssh" {
  name        = "allow-ssh"
  network     = module.gitlab-cicd-vpc.network_name
  description = "Allow SSH from personal IPs"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["82.77.79.10/32", "212.146.66.99/32"]
}

resource "google_compute_firewall" "personal-https" {
  name        = "allow-https"
  network     = module.gitlab-cicd-vpc.network_name
  description = "Allow https from personal IPs"

  allow {
    protocol = "tcp"
    ports    = ["443", "80"]
  }

  source_ranges = ["82.77.79.10/32", "212.146.66.99/32"]
}

resource "google_compute_firewall" "gitlab-runner" {
  name        = "allow-ssh-from-gitlabrunner"
  network     = module.gitlab-cicd-vpc.network_name
  description = "Allow SSH from Gitlab runner to docker machines"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["gitlab-runner"]
  target_tags = ["docker-machine"]
}

resource "google_compute_firewall" "gitlab-runner-traffic" {
  name        = "allow-https-from-gitlabrunner"
  network     = module.gitlab-cicd-vpc.network_name
  description = "Allow https from Gitlab runner to gitlab"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_tags = ["gitlab-runner"]
  target_tags = ["gitlab"]
}

resource "google_compute_firewall" "iap" {
  name        = "allow-iap"
  network     = module.gitlab-cicd-vpc.network_name
  description = "Allow Identity Aware proxy range"

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_address" "runner-ip" {
  name   = "gitlab-runner-ip"
  region = var.region
}

resource "google_compute_router" "gitlab-router" {
  name    = "gitlab-cicd-router"
  project = var.project_id
  region  = var.region
  network = module.gitlab-cicd-vpc.network_name
}
resource "google_compute_router_nat" "gitlab-nat" {
  name                               = "gitlab-cicd-router"
  router                             = google_compute_router.gitlab-router.name
  region                             = google_compute_router.gitlab-router.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
  nat_ips                            = google_compute_address.runner-ip.*.self_link

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
