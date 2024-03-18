resource "aws_route_table" "infrastructure_route_table" {
  vpc_id = aws_vpc.infrastructure_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infrastructure_igw.id
  }
}

resource "aws_route_table_association" "route-ec2-subnet-to-igw" {
  subnet_id      = aws_subnet.ec2_public_subnet.id
  route_table_id = aws_route_table.infrastructure_route_table.id
}
