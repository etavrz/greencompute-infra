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

## Storage import
import {
  to = module.rds.aws_db_instance.greencompute_db
  id = "${var.project_name}-db"
}

import {
  to = aws_s3_bucket.greencompute_bucket
  id = "${var.project_name}"
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
  source       = "./modules/container-registries"
  project_name = var.project_name
  tags         = local.tags
}

module "network" {
  source = "./modules/networking"
  tags   = local.tags
}

module "rds" {
  source = "./modules/rds"
  tags   = local.tags
}

module "ecs" {
  source            = "./modules/ecs"
  ecr_webserver     = module.ecr.ecr_webserver
  ecr_frontend      = module.ecr.ecr_frontend
  ecr_backend       = module.ecr.ecr_backend
  vpc_id            = module.network.vpc_id
  subnet_1_id       = module.network.subnet_1_id
  subnet_2_id       = module.network.subnet_2_id
  security_group_id = module.sg.security_group_id
  secret_id         = var.secret_id
  tags              = local.tags
}

module "sg" {
  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  source         = "./modules/security-group"
  project_name   = var.project_name
  tags           = local.tags
}

resource "aws_s3_bucket" "greencompute_bucket" {
  bucket = "${var.project_name}"
  tags   = local.tags
  force_destroy = true
}
