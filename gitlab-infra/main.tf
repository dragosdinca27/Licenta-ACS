# terraform {
#   backend "http" {
#   }
# }
locals {
  resource_prefix = "${var.project_base_name}-${var.project_environment}"
}
