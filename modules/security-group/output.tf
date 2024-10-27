output "security_group_id" {
	value = aws_security_group.greencompute_security_group.id
	description = "The ID of the security group"
	
}