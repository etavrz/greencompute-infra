resource "aws_ecr_repository" "greencompute_test" {
  name                 = "greencompute-test"
  image_tag_mutability = "MUTABLE"

  tags = {
    project     = var.project_name
    environment = "test"
  }
}

# Create an iam user with access to the ECR repository
resource "aws_iam_user" "greencompute_user" {
  name = "greencompute-user"

  tags = {
    project     = var.project_name
    environment = "test"
  }
}