resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Terraform-VPC"
  }
}


# [public_subnet[0],public_subnet[1]]
resource "aws_subnet" "public_subnet" {
  count = length(var.list_of_public_subnet_az)
  vpc_id = aws_vpc.myvpc.id
  availability_zone = element(var.list_of_public_subnet_az,count.index )
  cidr_block = element(var.list_of_public_subnet_cidr, count.index )

  lifecycle {
    precondition {
      condition     = length(var.list_of_public_subnet_az) / length(var.list_of_public_subnet_cidr) == 1
      error_message = "The length of list_of_public_subnet_az  (${length(var.list_of_public_subnet_az)}) must be equals to  length of list_of_public_subnet_cidr (${length(var.list_of_public_subnet_cidr)})."
    }
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.list_of_private_subnet_az)
  vpc_id = aws_vpc.myvpc.id
  availability_zone = element(var.list_of_private_subnet_az,count.index )
  cidr_block = element(var.list_of_private_subnet_cidr, count.index )
  lifecycle {
    precondition {
      condition     = length(var.list_of_private_subnet_az) / length(var.list_of_private_subnet_cidr) == 1
      error_message = "The length of list_of_private_subnet_az  (${length(var.list_of_private_subnet_az)}) must be equals to  length of list_of_private_subnet_cidr (${length(var.list_of_private_subnet_cidr)})."
    }
  }
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

resource "aws_route_table" "private_route_table"{
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource aws_nat_gateway "nat_gateway" {
  subnet_id = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat_gateway_eip.id
}

resource aws_eip "nat_gateway_eip"{

}

resource "aws_route_table_association" "public_subnets_association" {
  count = length(var.list_of_public_subnet_az)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
}

resource "aws_route_table_association" "private_subnets_association" {
  count = length(var.list_of_private_subnet_az)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = element(aws_subnet.private_subnet[*].id, count.index)
}
