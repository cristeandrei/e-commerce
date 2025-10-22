data "aws_ami" "l2023-ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "e-commerce-ec2" {
  ami           = data.aws_ami.l2023-ami.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id              = aws_subnet.e-commerce-subnet-private-b1.id

  tags = {
    Name    = "e-commerce-ec2",
    Project = "e-commerce"
  }
}
