data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "gc_cluster" {
	name = "greencompute-cluster"
	tags = var.tags
}

resource "aws_ecs_task_definition" "gc_task_def" {
	family                   = "greencompute-task"
	cpu                      = 1024
	memory                   = 2048
	network_mode             = "awsvpc"
	requires_compatibilities = ["FARGATE"]
	tags                     = var.tags
	execution_role_arn 		 	 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
	skip_destroy 					 	 = true	
	container_definitions = jsonencode([
		{
			name      = "webserver"
			image     = "${var.ecr_webserver}:latest"
			cpu       = 128
			memory    = 256
			essential = true
			portMappings = [
				{
					containerPort = 80
					hostPort      = 80
					protocol      = "tcp"
				}
			]
		},
		{
			name      = "backend"
			image     = "${var.ecr_backend}:latest"
			cpu       = 256
			memory    = 512
			essential = true
		},
		{
			name			= "frontend"
			image     = "${var.ecr_frontend}:latest"
			cpu       = 256
			memory    = 512
			essential = true
		}
	])
}


# Create a service to run the task
# resource "aws_ecs_service" "gc_service" {
# 	name            = "greencompute-service"
# 	cluster         = aws_ecs_cluster.gc_cluster.id
# 	task_definition = aws_ecs_task_definition.gc_task_def.arn
# 	desired_count   = 1
# 	network_configuration {
# 		subnets          = module.network.public_subnets
# 		security_groups  = [module.sg.security_group_id]
# 		assign_public_ip = true
# 	}
# 	depends_on = [aws_ecs_task_definition.gc_task_def]
# }