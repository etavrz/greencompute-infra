output "ecr_instace" {
  value = aws_ecr_repository.greencompute_test.repository_url
  description = "The URL of the ECR repository"
}

output "iam_user" {
  value = aws_iam_user.greencompute_user.id
  description = "The ID of the IAM user"
}