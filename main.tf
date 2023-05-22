resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Terraform-VPC"
  }
}

#resource "aws_subnet" "public_subnet_1" {
#  vpc_id = aws_vpc.myvpc.id
#  availability_zone = "us-east-1a"
#  cidr_block = "10.0.0.0/24"   ------> [10.0.0.0/24,10.0.5.0/24 ]
#}
#
#resource "aws_subnet" "public_subnet_2" {
#  vpc_id = aws_vpc.myvpc.id
#  availability_zone = "us-east-1b"
#  cidr_block = "10.0.5.0/24"
#}

# [public_subnet[0],public_subnet[1]]
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.myvpc.id
  availability_zone = element(var.list_of_public_subnet_az,count.index )
  cidr_block = element(var.list_of_public_subnet_cidr, count.index )
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.myvpc.id
  availability_zone = element(var.list_of_private_subnet_az,count.index )
  cidr_block = element(var.list_of_private_subnet_cidr, count.index )
}


resource "aws_route_table" "public_route_table"{
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "Terraform-Internet-Gateway"
  }
}

#resource "aws_subnet" "private_subnet_1" {
#  vpc_id = aws_vpc.myvpc.id
#  availability_zone = "us-east-1a"
#  cidr_block = "10.0.10.0/24"
#}
#
#resource "aws_subnet" "private_subnet_2" {
#  vpc_id = aws_vpc.myvpc.id
#  availability_zone = "us-east-1b"
#  cidr_block = "10.0.15.0/24"
#}


#resource "aws_route_table" "private_route_table"{
#  vpc_id = aws_vpc.myvpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_gateway.id
#  }
#}

#resource aws_nat_gateway "nat_gateway" {
#  subnet_id = aws_subnet.public_subnet_1.id
#  allocation_id = aws_eip.nat_gateway_eip.id
#}

resource aws_eip "nat_gateway_eip"{

}

#resource "aws_route_table_association" "public_subnet_1_association" {
#  route_table_id = aws_route_table.public_route_table.id
#  subnet_id = aws_subnet.public_subnet_1.id
#}

#resource "aws_route_table_association" "public_subnet_2_association" {
#  route_table_id = aws_route_table.public_route_table.id
#  subnet_id = aws_subnet.public_subnet_2.id
#}
#resource "aws_route_table_association" "private_subnet_1_association" {
#  route_table_id = aws_route_table.private_route_table.id
#  subnet_id = aws_subnet.private_subnet_1.id
#}
#resource "aws_route_table_association" "private_subnet_2_association" {
#  route_table_id = aws_route_table.private_route_table.id
#  subnet_id = aws_subnet.private_subnet_2.id
#}