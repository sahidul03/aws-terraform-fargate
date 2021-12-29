provider "aws" {
  region  = var.region
  profile = "sahidboss"
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "production_vpc" {
  cidr_block         = var.vpc_cidr
  enable_dns_support = true

  tags = {
    Name = "Production-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "Public-subnet-1"
    Type = "Public"
  }
}
resource "aws_subnet" "public_subnet_2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "Public-subnet-2"
    Type = "Public"
  }
}


resource "aws_subnet" "private_subnet_1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "Private-subnet-1"
    Type = "Private"
  }
}
resource "aws_subnet" "private_subnet_2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "Private-subnet-2"
    Type = "Private"
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "Private-Route-Table"
  }
}


resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "elastic_ip_for_nat_getway" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Product-EIP"
  }
}

resource "aws_nat_gateway" "nat_getway" {
  allocation_id = aws_eip.elastic_ip_for_nat_getway.id
  subnet_id     = aws_subnet.private_subnet_1.id

  tags = {
    Name = "Production NAT Getway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.elastic_ip_for_nat_getway]
}

resource "aws_route" "nat_getway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.nat_getway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "producttion_internet_getway" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "Product-internet-getway"
  }
}


resource "aws_route" "public_internet_getway_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.producttion_internet_getway.id
  destination_cidr_block = "0.0.0.0/0"
}