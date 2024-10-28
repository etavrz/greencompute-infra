variable "region" {
  description = "The region in which the resources will be created"
  type        = string
  default	    = "us-east-1"
}

variable "project_name" {
	description = "The name of the project"
  type        = string
  default	    = "greencompute"
}

variable "environment" {
  description = "The environment in which the resources will be created"
  type        = string
}

variable "secret_id" {
  description = "The ID of the secret"
  type        = string
}