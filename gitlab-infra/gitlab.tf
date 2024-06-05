resource "google_compute_instance" "gitlab" {
  name         = "gitlab"
  machine_type = "e2-medium"

  allow_stopping_for_update = true
  deletion_protection       = true

  tags = ["allow-ssh", "gitlab"]

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
    component   = "gitlab"
  }

  service_account {
    scopes = ["logging-write", "monitoring-write", "cloud-platform"]
  }
}

resource "google_compute_disk" "gitlab-disk" {
  name = "gitlab-prod-data-disk"
  zone = "${var.region}-c"

  type = "pd-ssd"
  size = "20"

  labels = {

  }
}



# resource "google_compute_resource_policy" "daily-snapshot" {
#   name   = "daily-snapshot"
#   region = var.region

#   snapshot_schedule_policy {
#     schedule {
#       daily_schedule {
#         days_in_cycle = 1
#         start_time    = "03:00"
#       }
#     }
#     retention_policy {
#       max_retention_days    = 7
#       on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
#     }
#     snapshot_properties {
#       labels = {
#         created_by  = "terraform"
#         environment = "production"
#         component   = "snapshot"
#       }
#     }
#   }
# }

# resource "google_compute_disk_resource_policy_attachment" "gitlab_datadisk_attachment" {
#   name = google_compute_resource_policy.daily-snapshot.name
#   disk = google_compute_disk.gitlab-disk.name
#   zone = "${var.region}-c"
# }
