/**
  * # Vpc
  *
  * Currently dns lookup between VPC isn't configured.
  * If this is needed add aws_vpc_peering_connection_options.
  *
  */

locals {
  public_subnet_name_prefix = "public"

  requester_peering_subnets = [
    for pair in setproduct(var.vpc_config.private_subnets, var.vpc_peering_config_requester) : {
      key                       = "${pair[1].name}-${pair[0].name_prefix}-${pair[0].availability_zone_index}"
      route_table_id            = aws_route_table.private["${pair[0].name_prefix}-${pair[0].availability_zone_index}"].id
      destination_cidr_block    = pair[1].destination_cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.this[pair[1].name].id
    }
  ]

  accepter_peering_subnets = [
    for pair in setproduct(var.vpc_config.private_subnets, var.vpc_peering_config_accepter) : {
      key                       = "${pair[1].name}-${pair[0].name_prefix}-${pair[0].availability_zone_index}"
      route_table_id            = aws_route_table.private["${pair[0].name_prefix}-${pair[0].availability_zone_index}"].id
      destination_cidr_block    = pair[1].destination_cidr_block
      vpc_peering_connection_id = data.aws_vpc_peering_connection.this[pair[1].name].id
    }
  ]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.global_tags
}

resource "aws_internet_gateway" "this" {
  for_each = {
    for s in ["internet"] :
    s => s
    if length(var.vpc_config.public_subnets) != 0
  }

  vpc_id = aws_vpc.this.id

  tags = local.global_tags
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
    local.global_tags,
    each.value.object.tags,
    {
      Name        = each.key,
    },
  )
}

resource "aws_eip" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  vpc = true

  tags = merge(
    local.global_tags,
    {
      Name        = each.key
    },
  )
}

resource "aws_nat_gateway" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  allocation_id = aws_eip.public[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    local.global_tags,
    {
      Name        = each.key
    },
  )
}

resource "aws_route_table" "public" {
  for_each = {
    for idx, subnet in var.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.global_tags,
    {
      Name        = each.key
    },
  )
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
    local.global_tags,
    each.value.tags,
    {
      Name        = each.key,
    },
  )
}

resource "aws_route_table" "private" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.global_tags,
    {
      Name        = each.key
    },
  )
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
    for value in var.vpc_peering_config_requester :
    value.name => value
  }

  peer_owner_id = each.value.peer_owner_id
  peer_vpc_id   = each.value.peer_vpc_id
  vpc_id        = aws_vpc.this.id
  auto_accept   = false

  tags = merge(
    local.global_tags,
    {
      Name        = each.key
      Side = "Requester"
    },
  )
}

resource "aws_route" "peering_requester" {
  for_each = {
    for value in local.requester_peering_subnets : value.key => value
  }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}

# Accepter's side of vpc peering
data "aws_vpc_peering_connection" "this" {
  for_each = {
    for value in var.vpc_peering_config_accepter :
    value.name => value
  }

  peer_vpc_id = aws_vpc.this.id
  #status      = "pending-acceptance"
  filter {
    values = [each.value.peer_owner_id]
    name   = "requester-vpc-info.owner-id"
  }
  filter {
    values = ["pending-acceptance", "active"]
    name   = "status-code"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  for_each = {
    for value in var.vpc_peering_config_accepter :
    value.name => value
  }

  vpc_peering_connection_id = data.aws_vpc_peering_connection.this[each.value.name].id
  auto_accept               = true

  tags = merge(
    local.global_tags,
    {
      Name = each.key
      Side = "Accepter"
    },
  )
}

resource "aws_route" "peering_accepter" {
  for_each = {
    for value in local.accepter_peering_subnets : value.key => value
  }
  depends_on = [
    aws_vpc_peering_connection_accepter.peer
  ]

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}
