resource "aws_vpc" "e-commerce-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "e-commerce-vpc",
    Project = "e-commerce"
  }
}

resource "aws_subnet" "e-commerce-subnet-public-a1" {
  vpc_id     = aws_vpc.e-commerce-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name    = "e-commerce-subnet-public-a1",
    Project = "e-commerce"
  }
}

resource "aws_subnet" "e-commerce-subnet-private-b1" {
  vpc_id     = aws_vpc.e-commerce-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name    = "e-commerce-subnet-private-b1",
    Project = "e-commerce"
  }
}

resource "aws_route_table" "e-commerce-public-route-table" {
  vpc_id = aws_vpc.e-commerce-vpc.id

  route = []

  tags = {
    Name    = "e-commerce-public-route-table",
    Project = "e-commerce"
  }
}

resource "aws_route_table" "e-commerce-private-route-table" {
  vpc_id = aws_vpc.e-commerce-vpc.id

  route = []

  tags = {
    Name    = "e-commerce-private-route-table",
    Project = "e-commerce"
  }
}

resource "aws_route_table_association" "e-commerce-public-route-table-to-subnet-public-a1" {
  subnet_id      = aws_subnet.e-commerce-subnet-public-a1.id
  route_table_id = aws_route_table.e-commerce-public-route-table.id
}

resource "aws_route_table_association" "e-commerce-private-route-table-to-subnet-private-b1" {
  subnet_id      = aws_subnet.e-commerce-subnet-private-b1.id
  route_table_id = aws_route_table.e-commerce-private-route-table.id
}

resource "aws_ec2_client_vpn_endpoint" "e-commerce-client-vpn-endpoint" {
  vpc_id                 = aws_vpc.e-commerce-vpc.id
  server_certificate_arn = "arn:aws:acm:eu-north-1:161887355492:certificate/963d2a5a-c4c2-49ae-bdbc-7bce346aa035"
  client_cidr_block      = "192.168.0.0/16"
  split_tunnel           = true

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:eu-north-1:161887355492:certificate/219e4e9e-5d7f-4e93-8c42-681118984814"
  }

  connection_log_options {
    enabled = false
  }

 security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name    = "e-commerce-client-vpn-endpoint",
    Project = "e-commerce"
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "e-commerce-client-vpn-endpoint-authorization-rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.e-commerce-client-vpn-endpoint.id
  target_network_cidr    = aws_vpc.e-commerce-vpc.cidr_block
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_network_association" "e-commerce-client-vpn-network-association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.e-commerce-client-vpn-endpoint.id
  subnet_id              = aws_subnet.e-commerce-subnet-public-a1.id
}
