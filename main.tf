terraform {
  cloud {
    organization = "greencompute"
    workspaces {
      name = "greencompute"
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

provider "aws" {
  region = var.region
}

# ====== ECR Imports =====
import {
  to = aws_ecr_repository.greencompute_frontend
  id = "${var.project_name}-frontend"
}

import {
  to = aws_ecr_repository.greencompute_webserver
  id = "${var.project_name}-webserver"
}

import {
  to = aws_ecr_repository.greencompute_backend
  id = "${var.project_name}-backend"
}


# ====== Resource Definitions =====
resource "aws_ecr_repository" "greencompute_frontend" {
  name = "${var.project_name}-frontend"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecr_repository" "greencompute_webserver" {
  name = "${var.project_name}-webserver"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecr_repository" "greencompute_backend" {
  name = "${var.project_name}-backend"
  lifecycle {
    prevent_destroy = true
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