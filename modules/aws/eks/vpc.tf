locals {
  subnet_offset = count(data.aws_availability_zones.names) - 1
  subnet_cidrs = cidrsubnets(data.aws_vpc.this.cidr_block, 2, 2, 2)
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_route_table" "default" {
  vpc_id = var.vpc_id
}

resource "aws_subnet" "this" {
  for_each = data.aws_availability_zones.names

  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnets()
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    "Name"        = "${var.environment}-${var.name}-${each.value.name}"
    "Environment" = var.environment
    "kubernetes.io/cluster/${var.environment}-${var.name}${var.eks_name_suffix}" = "shared"
  }
}

resource "aws_route_table_association" "this" {
  for_each = data.aws_availability_zones.names

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = data.aws_route_table.default.id
}
