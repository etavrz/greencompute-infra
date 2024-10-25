variable "region" {
  description = "The region in which the resources will be created"
  type        = string
  default	    = "us-east-1"
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
	description = "The CIDR block for the VPC"
	type        = string
	default     = "10.0.0.0/16"
}