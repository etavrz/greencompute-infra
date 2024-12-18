resource "aws_security_group" "greencompute_security_group" {
  name        = "${var.project_name}-security-group"
  description = "Security group for ${var.project_name}"
  vpc_id      = var.vpc_id
	tags				= var.tags 
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.greencompute_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.greencompute_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "streamlit_ipv4" {
  security_group_id = aws_security_group.greencompute_security_group.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 8501
  to_port           = 8501
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "postgrest_ipv4" {
  security_group_id = aws_security_group.greencompute_security_group.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
	security_group_id = aws_security_group.greencompute_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
