output "iam_user" {
  value = aws_iam_user.greencompute_user.id
  description = "The ID of the IAM user"
}

output "vpc_id" {
  value = module.network.vpc_id
  description = "The ID of the VPC"
}

output "ecr_backend" {
  value = module.ecr.ecr_backend
  description = "The URL of the ECR repository"
}

output "ecr_frontend" {
  value = module.ecr.ecr_frontend
  description = "The URL of the ECR repository"
}

output "ecr_webserver" {
  value = module.ecr.ecr_webserver
  description = "The URL of the ECR repository"
}