resource "google_compute_instance" "runner" {
  name         = "gitlab-runner"
  machine_type = "e2-micro"

  allow_stopping_for_update = true
  deletion_protection       = true

  tags = ["allow-ssh", "gitlab-runner"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
      type  = "pd-ssd"
      size  = "20"
    }
  }

  network_interface {
    subnetwork = module.gitlab-cicd-vpc.subnets["europe-west3/gitlab-prod-subnet-cicd-01"].name

    access_config {
      // Ephemeral IP
    }
  }

  labels = {
    created_by  = "terraform"
    environment = "production"
    component   = "gitlab-runner"
  }

  service_account {
    scopes = ["logging-write", "monitoring-write", "cloud-platform"]
  }
}

resource "google_compute_disk" "gitlab" {
  name = "gitlab-runner-data-disk"
  zone = "${var.region}-c"

  type = "pd-ssd"
  size = "20"

  labels = {

  }
}
