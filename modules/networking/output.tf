output "vpc_id" {
	value = aws_vpc.main.id
	description = "The ID of the VPC"
}

output "vpc_cidr_block" {
	value = aws_vpc.main.cidr_block
	description = "The CIDR block of the VPC"
}

output "subnet_1_id" {
	value = aws_subnet.subnet.id
	description = "The ID of the first subnet"
}

output "subnet_2_id" {
	value = aws_subnet.subnet2.id
	description = "The ID of the second subnet"
}