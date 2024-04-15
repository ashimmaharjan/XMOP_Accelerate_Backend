//creatiing public subnet for ec2 
resource "aws_subnet" "public-subnet-1"{
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"   
  map_public_ip_on_launch = "true"   //it makes this a public subnet
  availability_zone = "ap-southeast-2a"
}

//creating another public subnet for ec2 
resource "aws_subnet" "public-subnet-2"{
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"   
  map_public_ip_on_launch = "true"   //it makes this a public subnet
  availability_zone = "ap-southeast-2b"
}

//Thus is the first private subnet for RDS.....
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true"   //it makes it private subnet
  availability_zone = "ap-southeast-2a"
}

//This is the second subnet for RDS......
resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "true"   //it makes it private
  availability_zone = "ap-southeast-2b"
}
