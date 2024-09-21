resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  
  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.main.id
  count      = length(var.cidr_public_subnet)
  cidr_block = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.availability_zone,count.index)

  tags = {
    Name = "public-subnet-${count.index +1}"
  }
}


resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.main.id
  count      = length(var.cidr_private_subnet)
  cidr_block = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.availability_zone,count.index)

  tags = {
    Name = "private-subnet-${count.index +1}"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "flask-app-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_subnet_association" {
  count = length(aws_subnet.subnet_public)
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_subnet_association" {
  count = length(aws_subnet.subnet_private)
  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}