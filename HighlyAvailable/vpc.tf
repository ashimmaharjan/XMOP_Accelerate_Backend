resource "aws_vpc" "highlyavailable_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "highlyavailable_vpc"
  }
}

# It enables our vpc to connect to the internet
resource "aws_internet_gateway" "highlyavailable_igw" {
  vpc_id = aws_vpc.highlyavailable_vpc.id
  tags = {
    Name = "highlyavailable_igw"
  }
}


resource "aws_subnet" "ec2_1_public_subnet" {
  vpc_id                  = aws_vpc.highlyavailable_vpc.id
  cidr_block              = var.subnet_cidrs[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "first ec2 public subnet"
  }
}

resource "aws_subnet" "ec2_2_public_subnet" {
  vpc_id                  = aws_vpc.highlyavailable_vpc.id
  cidr_block              = var.subnet_cidrs[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "second ec2 public subnet"
  }
}

resource "aws_subnet" "database_private_subnet" {
  vpc_id                  = aws_vpc.highlyavailable_vpc.id
  cidr_block              = var.subnet_cidrs[2]
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone
  tags = {
    Name = "database private subnet"
  }
}
