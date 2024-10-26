provider "aws" {
  region = var.region
}

# ====== ECR Imports =====

## ECR imports 
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

## RDS import
import {
  to = module.rds.aws_db_instance.greencompute_db
  id = "${var.project_name}-db"
}

# ====== Module Definitions =====
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

module "rds" {
  source = "./modules/rds"
}

module "sg" {
  vpc_id       = module.network.vpc_id
  source       = "./modules/security-group"
  project_name = var.project_name
}

# Create an iam user with access to the ECR repository
resource "aws_iam_user" "greencompute_user" {
  name = "${var.project_name}-user"

  tags = {
    project     = var.project_name
    environment = var.environment
  }
}
