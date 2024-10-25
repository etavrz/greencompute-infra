provider "aws" {
  region = var.region
}

# ====== ECR Imports =====
import {
  to = module.ecr.aws_ecr_repository.greencompute_frontend
  id = "${var.project_name}-frontend"
}

import {
  to = module.ecr.aws_ecr_repository.greencompute_webserver
  id = "${var.project_name}-webserver"
}

import {
  to = module.ecr.aws_ecr_repository.greencompute_backend
  id = "${var.project_name}-backend"
}

module "ecr" {
  source = "./modules/container-registries"

  project_name = var.project_name
  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

module "network" {
  source = "./modules/networking"
  
  tags = {
    project     = var.project_name
    environment = var.environment
  }
}


# Create an iam user with access to the ECR repository
resource "aws_iam_user" "greencompute_user" {
  name = "${var.project_name}-user"

  tags = {
    project     = var.project_name
    environment = "test"
  }
}