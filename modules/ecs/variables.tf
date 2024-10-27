variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "ecr_frontend" {
	description = "The ECR repository for the frontend"
	type        = string
}

variable "ecr_backend" {
	description = "The ECR repository for the backend"
	type        = string
}

variable "ecr_webserver" {
	description = "The ECR repository for the webserver"
	type        = string
}

variable "vpc_id" {
	description = "The ID of the VPC"
	type        = string
}

variable "subnet_1_id" {
	description = "The ID of the first subnet"
	type        = string
}

variable "subnet_2_id" {
	description = "The ID of the second subnet"
	type        = string
}

variable "security_group_id" {
	description = "The ID of the security group"
	type        = string
}