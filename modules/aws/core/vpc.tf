resource "aws_vpc" "this" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

# public subnets with NAT
resource "aws_subnet" "public" {
  for_each = {
    for subnet in var.vpc_config.public_subnets :
    subnet.name => subnet
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = data.aws_availability_zones.available.names[each.value.availability_zone_index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = each.value.name
    Environment              = var.environment
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_eip" "public" {
  for_each = {
    for subnet in var.vpc_config.public_subnets :
    subnet.name => subnet
  }

  vpc = true

  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "public" {
  for_each = {
    for subnet in var.vpc_config.public_subnets :
    subnet.name => subnet
  }

  allocation_id = aws_eip.public[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  for_each = {
    for subnet in var.vpc_config.public_subnets :
    subnet.name => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  for_each = {
    for subnet in var.vpc_config.public_subnets :
    subnet.name => subnet
  }

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = {
    for subnet in var.vpc_config.public_subnets :
    subnet.name => subnet
  }

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

# Private subnetes with egress routing through NAT
resource "aws_subnet" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    subnet.name => subnet
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = data.aws_availability_zones.available.names[each.value.availability_zone_index]

  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    subnet.name => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    subnet.name => subnet
  }

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public["pub${each.value.availability_zone_index}"].id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    subnet.name => subnet
  }

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

# VPC Peering
resource "aws_vpc_peering_connection" "this" {
  for_each = {
    for s in ["peering"] :
    s => s
    if var.vpc_peering_enabled
  }

  peer_owner_id = var.vpc_peering_config.peer_owner_id
  peer_vpc_id   = var.vpc_peering_config.peer_vpc_id
  vpc_id        = aws_vpc.this.id
  auto_accept   = false

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "peer" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    subnet.name => subnet
    if var.vpc_peering_enabled
  }

  route_table_id            = aws_route_table.private[each.key].id
  destination_cidr_block    = var.vpc_peering_config.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id
}
