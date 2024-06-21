resource "aws_vpc" "roboshop" {
    cidr_block = var.cidr_block
    enable_dns_support = var.enable_dns_support 
    enable_dns_hostnames = var.enable_dns_hostnames 
    tags = merge(var.comman_tags, var.vpc_tags)
}
resource "aws_internet_gateway" "roboshop_igw" {
    vpc_id = aws_vpc.roboshop.id
    tags = merge(var.comman_tags, var.igw_tags)
}
resource "aws_subnet" "roboshop_public" {
    count = length(var.public_cidr_block)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.public_cidr_block[count.index]
    availability_zone = var.az[count.index]
    tags = merge(var.comman_tags,{ Name =  var.public_subnet_names[count.index]})
}
resource "aws_subnet" "roboshop_private" {
    count = length(var.private_cidr_block)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.private_cidr_block[count.index]
    availability_zone = var.az[count.index]
    tags = merge(var.comman_tags,{ Name =  var.private_subnet_names[count.index]})
}
resource "aws_subnet" "roboshop_database" {
    count = length(var.database_cidr_block)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.database_cidr_block[count.index]
    availability_zone = var.az[count.index]
    tags = merge(var.comman_tags,{ Name =  var.database_subnet_names[count.index]})
}
resource "aws_route_table" "roboshop_public" {
  vpc_id = aws_vpc.roboshop.id
  tags = merge(var.comman_tags, var.public_route_tags)
}
resource "aws_route" "roboshop_public" {
  route_table_id = aws_route_table.roboshop_public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.roboshop_igw.id
  depends_on = [aws_route_table.roboshop_public]
}
resource "aws_route_table" "roboshop_private" {
  vpc_id = aws_vpc.roboshop.id
  tags = merge(var.comman_tags, var.private_route_tags)
}
resource "aws_route_table" "roboshop_database" {
  vpc_id = aws_vpc.roboshop.id
  tags = merge(var.comman_tags, var.database_route_tags)
}
resource "aws_route_table_association" "roboshop_pubsub_route_association" {
  count = length(var.public_cidr_block)
  subnet_id      = element(aws_subnet.roboshop_public[*].id, count.index)
  route_table_id = aws_route_table.roboshop_public.id
}
resource "aws_route_table_association" "roboshop_prisub_route_association" {
  count = length(var.private_cidr_block)
  subnet_id      = element(aws_subnet.roboshop_private[*].id, count.index)
  route_table_id = aws_route_table.roboshop_private.id
}
resource "aws_route_table_association" "roboshop_datasub_route_association" {
  count = length(var.database_cidr_block)
  subnet_id      = element(aws_subnet.roboshop_database[*].id, count.index)
  route_table_id = aws_route_table.roboshop_database.id
}
