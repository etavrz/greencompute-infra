output "iam_user" {
  value = aws_iam_user.greencompute_user.id
  description = "The ID of the IAM user"
}

output "ecr_instance" {
  value = module.ecr.ecr_instace
  description = "The URL of the ECR repository"
}

output "vpc_id" {
  value = module.network.vpc_id
  description = "The ID of the VPC"
}