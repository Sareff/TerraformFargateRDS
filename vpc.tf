resource "aws_vpc" "vpc-task-2" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-task-2"
  }
}

resource "aws_subnet" "public-a-task-2" {
  cidr_block        = "10.0.10.0/24"
  vpc_id            = aws_vpc.vpc-task-2.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = "public-a-task-2"
  }
}

resource "aws_subnet" "public-b-task-2" {
  cidr_block        = "10.0.11.0/24"
  vpc_id            = aws_vpc.vpc-task-2.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "public-b-task-2"
  }
}

resource "aws_subnet" "private-a1-task-2" {
  cidr_block        = "10.0.20.0/24"
  vpc_id            = aws_vpc.vpc-task-2.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = "private-a1-task-2"
  }
}

resource "aws_subnet" "private-b1-task-2" {
  cidr_block        = "10.0.21.0/24"
  vpc_id            = aws_vpc.vpc-task-2.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-b1-task-2"
  }
}

resource "aws_subnet" "private-a2-task-2" {
  cidr_block        = "10.0.30.0/24"
  vpc_id            = aws_vpc.vpc-task-2.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = "private-a2-task-2"
  }
}

resource "aws_subnet" "private-b2-task-2" {
  cidr_block        = "10.0.31.0/24"
  vpc_id            = aws_vpc.vpc-task-2.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-b2-task-2"
  }
}

resource "aws_internet_gateway" "ig-task-2" {
  vpc_id = aws_vpc.vpc-task-2.id

  tags = {
    Name = "ig-task-2"
  }
}

resource "aws_eip" "eip-a-task-2" {
  vpc = true
  tags = {
    Name = "eip-a-task-2"
  }
}

resource "aws_eip" "eip-b-task-2" {
  vpc = true
  tags = {
    Name = "eip-b-task-2"
  }
}

resource "aws_nat_gateway" "nat-a-task-2" {
  subnet_id     = aws_subnet.public-a-task-2.id
  allocation_id = aws_eip.eip-a-task-2.id

  tags = {
    Name = "nat-a-task-2"
  }
}

resource "aws_nat_gateway" "nat-b-task-2" {
  subnet_id     = aws_subnet.public-b-task-2.id
  allocation_id = aws_eip.eip-b-task-2.id

  tags = {
    Name = "nat-b-task-2"
  }
}

resource "aws_route_table" "public-rt-task-2" {
  vpc_id = aws_vpc.vpc-task-2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-task-2.id
  }

  tags = {
    Name = "public-rt-task-2"
  }
}

resource "aws_route_table" "private-a-task-2" {
  vpc_id = aws_vpc.vpc-task-2.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-a-task-2.id
  }

  tags = {
    Name = "private-a-task-2"
  }
}

resource "aws_route_table" "private-b-task-2" {
  vpc_id = aws_vpc.vpc-task-2.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-b-task-2.id
  }

  tags = {
    Name = "private-b-task-2"
  }
}

resource "aws_route_table_association" "private-a1-assc-task-2" {
  subnet_id      = aws_subnet.private-a1-task-2.id
  route_table_id = aws_route_table.private-a-task-2.id
}

resource "aws_route_table_association" "private-b1-assc-task-2" {
  subnet_id      = aws_subnet.private-b1-task-2.id
  route_table_id = aws_route_table.private-b-task-2.id
}

resource "aws_route_table_association" "public-a-assc-task-2" {
  subnet_id      = aws_subnet.public-a-task-2.id
  route_table_id = aws_route_table.public-rt-task-2.id
}

resource "aws_route_table_association" "public-b-assc-task-2" {
  subnet_id      = aws_subnet.public-b-task-2.id
  route_table_id = aws_route_table.public-rt-task-2.id
}

resource "aws_route_table_association" "private-a2-assc-task-2" {
  subnet_id      = aws_subnet.private-a2-task-2.id
  route_table_id = aws_route_table.private-a-task-2.id
}

resource "aws_route_table_association" "private-b2-assc-task-2" {
  subnet_id      = aws_subnet.private-b2-task-2.id
  route_table_id = aws_route_table.private-b-task-2.id
}