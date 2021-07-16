locals {
  public_subnet_name_prefix = "public"

  peering_subnets = [
    for pair in setproduct(var.vpc_config.private_subnets, var.vpc_peering_config) : {
      key                       = "${pair[1].name}-${pair[0].name_prefix}-${pair[0].availability_zone_index}"
      route_table_id            = "aws_route_table.private[${pair[0].name_prefix}-${pair[0].availability_zone_index}].id"
      destination_cidr_block    = pair[1].destination_cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.this[pair[1].name].id
    }
  ]
}



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
  for_each = {
    for s in ["internet"] :
    s => s
    if var.internet_gateway_enabled
  }

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

# public subnets with NAT
resource "aws_subnet" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => { index : idx, object : subnet }
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.object.cidr_block
  availability_zone       = data.aws_availability_zones.available.names[each.value.index]
  map_public_ip_on_launch = true

  tags = merge(
    each.value.object.tags,
    {
      Name        = each.key,
      Environment = var.environment
    }
  )
}

resource "aws_eip" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  vpc = true

  tags = {
    Name        = each.key
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  allocation_id = aws_eip.public[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name        = each.key
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = each.key
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this["internet"].id
}

resource "aws_route_table_association" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

# Private subnetes with egress routing through NAT
resource "aws_subnet" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = data.aws_availability_zones.available.names[each.value.availability_zone_index]

  tags = merge(
    each.value.tags,
    {
      Name        = each.key,
      Environment = var.environment
    }
  )
}

resource "aws_route_table" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = each.key
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
    if subnet.public_routing_enabled
  }

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public["${local.public_subnet_name_prefix}-${each.value.availability_zone_index}"].id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
  }

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

# VPC Peering
resource "aws_vpc_peering_connection" "this" {
  for_each = {
    for value in var.vpc_peering_config :
    value.name => value
  }

  peer_owner_id = each.value.peer_owner_id
  peer_vpc_id   = each.value.peer_vpc_id
  vpc_id        = aws_vpc.this.id
  auto_accept   = false

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    "Name" = each.key
    "Side" = "Requester"
  }
}

data "aws_vpc_peering_connection" "this" {
  for_each = {
    for s in ["peer"] :
    s => s
    if var.vpc_peer_enabled
  }
  peer_vpc_id = aws_vpc.this.id
  status      = "pending-acceptance"
  filter {
    values = [var.requester_account]
    name   = "requester-vpc-info.owner-id"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  for_each = {
    for s in ["peer"] :
    s => s
    if var.vpc_peer_enabled
  }

  vpc_peering_connection_id = data.aws_vpc_peering_connection.this["peer"].id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_route" "peer" {
  for_each = {
    for value in local.peering_subnets : value.key => value
  }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}
