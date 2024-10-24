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
}

resource "aws_ecr_repository" "greencompute_webserver" {
  name = "${var.project_name}-webserver"
}

resource "aws_ecr_repository" "greencompute_backend" {
  name = "${var.project_name}-backend"
}


# Create an iam user with access to the ECR repository
resource "aws_iam_user" "greencompute_user" {
  name = "${var.project_name}-user"

  tags = {
    project     = var.project_name
    environment = "test"
  }
}