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
	task_role_arn 					 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
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
		runtime_platform {
		operating_system_family = "LINUX"
		cpu_architecture 				= "X86_64"
	}
}


resource "aws_lb" "gc_lb" {
	name 						 	 = "greencompute-lb"
	internal 				 	 = false
	load_balancer_type = "application"
	security_groups 	 = [var.security_group_id]
	subnets 					 = [var.subnet_1_id, var.subnet_2_id]
	tags 						 	 = var.tags
}

resource "aws_lb_target_group" "gc_tg" {
	name        = "greencompute-tg"
	port        = 80
	protocol    = "HTTP"
	vpc_id      = var.vpc_id
	target_type = "ip"	
	health_check {
		path = "/"
	}
}

resource "aws_lb_listener" "gc_listener" {
	load_balancer_arn = aws_lb.gc_lb.arn
	port 						 = 80
	protocol 				 = "HTTP"
	default_action {
		type             = "forward"
		target_group_arn = aws_lb_target_group.gc_tg.arn
	}
	
}

resource "aws_ecs_service" "gc_service" {
	name            = "greencompute-service"
	cluster         = aws_ecs_cluster.gc_cluster.id
	task_definition = aws_ecs_task_definition.gc_task_def.arn
	desired_count   = 1
	force_new_deployment = true

	load_balancer {
		target_group_arn = aws_lb_target_group.gc_tg.arn
		container_name    = "webserver"
		container_port    = 80
	}
	network_configuration {
		subnets          = [var.subnet_1_id, var.subnet_2_id]
		security_groups  = [var.security_group_id]
	}
	depends_on = [aws_ecs_task_definition.gc_task_def]
}