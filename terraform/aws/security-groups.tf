resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  vpc_id      = aws_vpc.e-commerce-vpc.id

  tags = {
    Name = "allow_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ingress_ipv4" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = aws_vpc.e-commerce-vpc.cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}