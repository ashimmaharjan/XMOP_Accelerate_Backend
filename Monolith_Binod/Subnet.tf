//creatiing public subnet for ec2 
resource "aws_subnet" "public-subnet-1"{
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"   
  map_public_ip_on_launch = "true"   //it makes this a public subnet
  availability_zone = "ap-southeast-2a"
}