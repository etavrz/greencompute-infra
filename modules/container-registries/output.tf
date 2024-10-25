output "ecr_instace" {
  value = aws_ecr_repository.greencompute_backend.id
  description = "The URL of the ECR repository"
}