provider "aws" {
access_key = "XXX"
secret_key = "XXX"
region = "eu-central-1"
}

resource "aws_instance" "terraform_ubuntu_test2" {
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  key_name      = "key_pair_fra_1"
  subnet_id     = aws_subnet.terraform_subnet_2.id
  vpc_security_group_ids = [aws_security_group.terraform_sg_2.id]
  tags          = {
    Name = "terraform_test_2"
  }
  user_data     = file("user-data.sh")
}


resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc_2.id

  tags = {
    Name = "terraform_igw"
  }
}


resource "aws_route_table" "terraform_route_table" {
  vpc_id = aws_vpc.terraform_vpc_2.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

}
resource "aws_route_table_association" "terraform_subnet_2" {
  subnet_id      = aws_subnet.terraform_subnet_2.id
  route_table_id = aws_route_table.terraform_route_table.id
}


resource "aws_vpc" "terraform_vpc_2" {
  cidr_block       = "10.2.2.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "terraform_vpc_2"
  }
}


resource "aws_subnet" "terraform_subnet_2" {
  vpc_id            = aws_vpc.terraform_vpc_2.id
  cidr_block        = "10.2.2.64/26"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "terraform_subnet_2"
  }
}


resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["5.18.247.0/24"]
  security_group_id = "${aws_security_group.terraform_sg_2.id}"
}


resource "aws_security_group_rule" "flask" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["5.18.247.0/24"]
  security_group_id = "${aws_security_group.terraform_sg_2.id}"
}


resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.terraform_sg_2.id}"
}


resource "aws_security_group_rule" "tcp_inside" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.2.2.0/24"]
  security_group_id = "${aws_security_group.terraform_sg_2.id}"
}


resource "aws_security_group_rule" "MySQL" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.2.2.0/24"]
  security_group_id = "${aws_security_group.terraform_sg_2.id}"
}


resource "aws_security_group_rule" "allow_all_outside" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.terraform_sg_2.id}"
}



resource "aws_security_group" "terraform_sg_2" {
  name        = "terrafrom_sg_2"
  description = "Allow SSH inbound traffic from 5.18.247.0/24"
  vpc_id      = aws_vpc.terraform_vpc_2.id
  tags = {
    Name = "terraform_sg_2"
  }
}
