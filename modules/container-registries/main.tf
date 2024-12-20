
# ====== Resource Definitions =====
resource "aws_ecr_repository" "greencompute_frontend" {
  name = "${var.project_name}-frontend"
  tags = var.tags
  force_delete = true
}

resource "aws_ecr_repository" "greencompute_webserver" {
  name = "${var.project_name}-webserver"
  tags = var.tags
  force_delete = true
}

resource "aws_ecr_repository" "greencompute_backend" {
  name = "${var.project_name}-backend"
  tags = var.tags
  force_delete = true
}
