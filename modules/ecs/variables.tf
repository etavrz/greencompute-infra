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
