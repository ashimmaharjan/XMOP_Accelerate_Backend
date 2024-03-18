resource "aws_vpc" "infrastructure_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Wordpress-vpc"
  }
}

resource "aws_internet_gateway" "infrastructure_igw" {
  vpc_id = aws_vpc.infrastructure_vpc.id
  tags = {
    Name = "Wordpress_igw"
  }
}

resource "aws_subnet" "ec2_public_subnet" {
  vpc_id                  = aws_vpc.infrastructure_vpc.id
  cidr_block              = var.subnet_cidrs[1]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone[0]
  tags = {
    Name = "ec2 public subnet"
  }
}

resource "aws_subnet" "database_private_subnet_1" {
  vpc_id                  = aws_vpc.infrastructure_vpc.id
  cidr_block              = var.subnet_cidrs[4]
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone[1]
  tags = {
    Name = "database private subnet 1"
  }
}

# database read replica private subnet
resource "aws_subnet" "database_private_subnet_2" {
  vpc_id                  = aws_vpc.infrastructure_vpc.id
  cidr_block              = var.subnet_cidrs[3]
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zone[0]
  tags = {
    Name = "database private subnet 2"
  }
}

resource "aws_db_subnet_group" "database_subnet" {
  name       = "db subnet"
  subnet_ids = [aws_subnet.database_private_subnet_1.id, aws_subnet.database_private_subnet_2.id]
}
