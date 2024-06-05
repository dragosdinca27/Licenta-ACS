terraform {
  required_version = "0.13.4"

  backend "http" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.12"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}
