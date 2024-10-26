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
# Set a local tags variable to be used in all modules
locals {
  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

module "ecr" {
  source = "./modules/container-registries"
  project_name = var.project_name
  tags = local.tags
}

module "network" {
  source = "./modules/networking"
  tags = local.tags
}

module "rds" {
  source = "./modules/rds"
  tags = local.tags
}

module "ecs" {
  source = "./modules/ecs"
  tags = local.tags
}

module "sg" {
  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  source         = "./modules/security-group"
  project_name   = var.project_name
  tags = local.tags
}

# Create an iam user with access to the ECR repository
resource "aws_iam_user" "greencompute_user" {
  name = "${var.project_name}-user"
  tags = local.tags
}
