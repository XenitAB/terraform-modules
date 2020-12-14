#locals {
#  subnet_offset = count(data.aws_availability_zones.available.names) - 1
#}

data "aws_vpc" "this" {
  tags = {
    Name = "wwkcore"
  }
}

data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.this.id
}

resource "aws_subnet" "this" {
  for_each   = { for idx, az in data.aws_availability_zones.available.names: az => idx}

  vpc_id                  = data.aws_vpc.this.id
  cidr_block              = cidrsubnet(data.aws_vpc.this.cidr_block, 2, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    "Name"        = "${var.environment}-${var.name}-${each.key}"
    "Environment" = var.environment
    "kubernetes.io/cluster/${var.environment}-${var.name}${var.eks_name_suffix}" = "shared"
  }
}

resource "aws_route_table_association" "this" {
  for_each = data.aws_availability_zones.available.names

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = data.aws_route_table.default.id
}
