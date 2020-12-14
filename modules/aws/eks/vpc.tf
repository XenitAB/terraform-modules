data "aws_vpc" "this" {
  tags = {
    Name = var.core_name
  }
}

data "aws_nat_gateway" "this" {
  for_each = { for idx, az in data.aws_availability_zones.available.names : az => idx }

  vpc_id = data.aws_vpc.this.id

  tags = {
    Name = "${var.core_name}-${each.value}"
  }
}

resource "aws_subnet" "this" {
  for_each = { for idx, az in data.aws_availability_zones.available.names : az => idx }

  vpc_id            = data.aws_vpc.this.id
  cidr_block        = cidrsubnet(var.eks_config.cidr_block, 2, each.value)
  availability_zone = each.key

  tags = {
    "Name"                                                                       = "${var.environment}-${var.name}-private-${each.value}"
    "Environment"                                                                = var.environment
    "kubernetes.io/cluster/${var.environment}-${var.name}${var.eks_name_suffix}" = "shared"
  }
}

resource "aws_route_table" "this" {
  for_each = { for idx, az in data.aws_availability_zones.available.names : az => idx }

  vpc_id = data.aws_vpc.this.id

  tags = {
    "Name"        = "${var.environment}-${var.core_name}-${var.name}${var.eks_name_suffix}-private-${each.value}"
    "Environment" = var.environment
  }
}

resource "aws_route_table_association" "this" {
  for_each = { for idx, az in data.aws_availability_zones.available.names : az => idx }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[each.key].id
}

resource "aws_route" "this" {
  for_each = { for idx, az in data.aws_availability_zones.available.names : az => idx }

  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.this[each.key].id
}
