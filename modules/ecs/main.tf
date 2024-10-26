resource "aws_ecs_cluster" "ecs_cluster" {
	name = "greencompute-cluster"
	tags = var.tags
}