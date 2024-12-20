data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret_version" "gc_secret" {
  secret_id = var.secret_id
}

locals {
  gc_secrets = jsondecode(data.aws_secretsmanager_secret_version.gc_secret.secret_string)

  gc_secrets_list = [
    for name, value in local.gc_secrets : {
      name  = name
      value = value
    }
  ]
}

resource "aws_ecs_cluster" "gc_cluster" {
	name = "greencompute-cluster"
	tags = var.tags
}

resource "aws_cloudwatch_log_group" "gc_log_group" {
	name = "/ecs/greencompute_logs"
	retention_in_days = 7
}

resource "aws_ecs_task_definition" "gc_task_def" {
	family                   = "greencompute-task"
	cpu                      = 2048
	memory                   = 4096
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
			logConfiguration = {
				logDriver = "awslogs"
				options = {
					"awslogs-group" 			  = aws_cloudwatch_log_group.gc_log_group.name
					"awslogs-region" 				= "us-east-1"
					"awslogs-stream-prefix" = "webserver"
				}
			}
		},
		{
			name      			 = "backend"
			image     			 = "${var.ecr_backend}:latest"
			cpu       			 = 512
			memory    			 = 1024
			essential 			 = true
			environment 		 = local.gc_secrets_list
			logConfiguration = {
				logDriver = "awslogs"
				options 	= {
					"awslogs-group" 			  = aws_cloudwatch_log_group.gc_log_group.name
					"awslogs-region" 				= "us-east-1"
					"awslogs-stream-prefix" = "webserver"
				}
			}
		},
		{
			name						 = "frontend"
			image     			 = "${var.ecr_frontend}:latest"
			cpu       			 = 512
			memory    			 = 1024
			essential 			 = true
			logConfiguration = {
				logDriver = "awslogs"
				options = {
					"awslogs-group" 			  = aws_cloudwatch_log_group.gc_log_group.name
					"awslogs-region" 				= "us-east-1"
					"awslogs-stream-prefix" = "webserver"
				}
			}
		}
	])
		runtime_platform {
		operating_system_family = "LINUX"
		cpu_architecture 				= "X86_64"
	}
}


resource "aws_lb" "gc_lb" {
	name 						 	 = "greencompute"
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
	name            		 = "greencompute-service"
	cluster         		 = aws_ecs_cluster.gc_cluster.id
	task_definition 		 = aws_ecs_task_definition.gc_task_def.arn
	desired_count   		 = 1
	force_new_deployment = true
	launch_type 				 = "FARGATE"	

	load_balancer {
		target_group_arn 	= aws_lb_target_group.gc_tg.arn
		container_name    = "webserver"
		container_port    = 80
	}
	network_configuration {
		subnets          = [var.subnet_1_id, var.subnet_2_id]
		security_groups  = [var.security_group_id]
		assign_public_ip = true
	}
}