//creatiing public subnet for ec2 
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.subnet_availability_zone
}
