output "ecr_backend" {
  value = aws_ecr_repository.greencompute_backend.repository_url
  description = "The URL of the ECR repository"
}

output "ecr_frontend" {
  value = aws_ecr_repository.greencompute_frontend.repository_url
  description = "The URL of the ECR repository"
}

output "ecr_webserver" {
  value = aws_ecr_repository.greencompute_webserver.repository_url
  description = "The URL of the ECR repository"
}