resource "aws_vpc" "this" {
  cidr_block           = var.vpc_config.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  for_each   = { for idx, az in data.aws_availability_zones.available.names: az => idx}

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_config.public_cidr_block, 2, each.value)
  availability_zone       = each.key

  tags = {
    Name        = "${var.name}-public-${each.value}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-public"
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each   = { for idx, az in data.aws_availability_zones.available.names: az => idx}

  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[each.key].id
}

resource "aws_eip" "nat" {
  for_each   = { for idx, az in data.aws_availability_zones.available.names: az => idx}

  vpc      = true

  tags = {
    Name        = "${var.name}-${each.value}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat" {
  for_each   = { for idx, az in data.aws_availability_zones.available.names: az => idx}

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name        = "${var.name}-${each.value}"
    Environment = var.environment
  }
}
