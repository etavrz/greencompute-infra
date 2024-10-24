variable "region" {
  description = "The region in which the resources will be created"
  type        = string
  default	    = "us-east-1"
}

variable "project_name" {
	description = "The name of the project"
  type        = string
  default	 = "greencompute"
}

variable "ecr_services" {
  type    = list(string)
  default = ["frontend", "webserver", "backend"]
}
