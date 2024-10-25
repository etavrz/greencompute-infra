terraform {
  cloud {
    organization = "greencompute"
    workspaces {
      name = "greencompute-tf"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72.1"
    }
  }

  required_version = ">= 1.2.0"
}
