variable vpc_id {
	description = "The ID of the VPC"
	type        = string
}

variable "vpc_cidr_block" {
	description = "The CIDR block of the VPC"
	type        = string
}

variable "project_name" {
	description = "The name of the project"
  type        = string
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}
