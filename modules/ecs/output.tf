output "load_balancer_dns" {
	value = aws_lb.gc_lb.dns_name
	description = "The DNS name of the load balancer"
}