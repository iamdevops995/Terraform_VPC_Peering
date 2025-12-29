resource "aws_vpc" "vpc-a" {
  cidr_block = var.vpc-a-cicd
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_vpc" "vpc-b" {
  cidr_block = var.vpc-b-cicd
  enable_dns_hostnames = true
  enable_dns_support = true
}

#subnet

resource "aws_subnet" "subnet-A" {
  vpc_id     = aws_vpc.vpc-a.id
  cidr_block = var.sub-a-cicd
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-B" {
  vpc_id     = aws_vpc.vpc-b.id
  cidr_block = var.sub-b-cicd
  map_public_ip_on_launch = true
}

resource "aws_vpc_peering_connection" "vpc-peering" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.vpc-b.id
  vpc_id        = aws_vpc.vpc-a.id
  auto_accept   = true

  tags = {
    Name="vpc-peering"
  }
}

resource "aws_route" "route-a-to-b" {
  route_table_id = aws_route_table.RT-A.id
  destination_cidr_block = var.vpc-b-cicd
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
  
}

resource "aws_route" "route-b-to-a" {
  route_table_id = aws_route_table.RT-B.id
  destination_cidr_block = var.vpc-a-cicd
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}


resource "aws_route_table" "RT-A" {
  vpc_id = aws_vpc.vpc-a.id
  route {
    cidr_block                = var.vpc-b-cicd
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
  }
  tags = {
    Name="rt-a"
  }

}

resource "aws_route_table" "RT-B" {
  vpc_id = aws_vpc.vpc-b.id
  route {
    cidr_block                = var.vpc-a-cicd
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
  }
  tags = {
    Name="rt-b"
  }
}

resource "aws_route_table_association" "rt-a-sub1-ass" {
  route_table_id = aws_route_table.RT-A.id
  subnet_id      = aws_subnet.subnet-A.id
  
}

resource "aws_route_table_association" "sub2-ass" {
  route_table_id = aws_route_table.RT-B.id
  subnet_id      = aws_subnet.subnet-B.id
}

resource "aws_security_group" "websg-a" {
  name   = "web-sg"
  vpc_id = aws_vpc.vpc-a.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}


resource "aws_security_group" "websg-b" {
  name   = "web-sg"
  vpc_id = aws_vpc.vpc-b.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "test-1a" {
  ami             = var.ami
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg-a.id]
  subnet_id = aws_subnet.subnet-A.id

  tags = {
    Name = "test-1a"
  }
}

resource "aws_instance" "test-2b" {
  ami             = var.ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet-B.id
  vpc_security_group_ids = [aws_security_group.websg-b.id]

  tags = {
    Name = "test-2b"
  }
}
