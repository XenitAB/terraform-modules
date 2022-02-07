/**
  * # Vpc
  *
  * Currently dns lookup between VPC isn't configured.
  * If this is needed add aws_vpc_peering_connection_options.
  *
  */

locals {
  public_subnet_name_prefix       = "public"
  private_subnet_name_prefix      = "private"
  eks1_nodes_subnet_name_prefix   = "eks1-nodes"
  eks2_nodes_subnet_name_prefix   = "eks2-nodes"
  eks1_cluster_subnet_name_prefix = "eks1-cluster"
  eks2_cluster_subnet_name_prefix = "eks2-cluster"

  cidr_host  = cidrhost(var.cidr_block, 0)
  cidr_host2 = cidrhost(var.cidr_block, 9216)

  eks1_nodes_subnets = [
    {
      name_prefix             = local.eks1_nodes_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host}/18", 4, 3)
      availability_zone_index = 0
      public_routing_enabled  = true
      tags = {
        "kubernetes.io/cluster/eks1-${var.environment}" = "shared"
      }
    },
    {
      name_prefix             = local.eks1_nodes_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host}/18", 4, 4)
      availability_zone_index = 1
      public_routing_enabled  = true
      tags = {
        "kubernetes.io/cluster/eks1-${var.environment}" = "shared"
      }
    },
    {
      name_prefix             = local.eks1_nodes_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host}/18", 4, 5)
      availability_zone_index = 2
      public_routing_enabled  = true
      tags = {
        "kubernetes.io/cluster/eks1-${var.environment}" = "shared"
      }
    },
  ]
  eks1_cluster_subnets = [
    {
      name_prefix             = local.eks1_cluster_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host2}/24", 4, 0)
      availability_zone_index = 0
      public_routing_enabled  = false
      tags                    = {}
    },
    {
      name_prefix             = local.eks1_cluster_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host2}/24", 4, 1)
      availability_zone_index = 1
      public_routing_enabled  = false
      tags                    = {}
    },
  ]

  eks2_nodes_subnets = [
    {
      name_prefix             = local.eks2_nodes_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host}/18", 4, 6)
      availability_zone_index = 0
      public_routing_enabled  = true
      tags = {
        "kubernetes.io/cluster/eks2-${var.environment}" = "shared"
      }
    },
    {
      name_prefix             = local.eks2_nodes_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host}/18", 4, 7)
      availability_zone_index = 1
      public_routing_enabled  = true
      tags = {
        "kubernetes.io/cluster/eks2-${var.environment}" = "shared"
      }
    },
    {
      name_prefix             = local.eks2_nodes_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host}/18", 4, 8)
      availability_zone_index = 2
      public_routing_enabled  = true
      tags = {
        "kubernetes.io/cluster/eks2-${var.environment}" = "shared"
      }
    },
  ]

  eks2_cluster_subnets = [
    {
      name_prefix             = local.eks2_cluster_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host2}/24", 4, 2)
      availability_zone_index = 0
      public_routing_enabled  = false
      tags                    = {}
    },
    {
      name_prefix             = local.eks2_cluster_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host2}/24", 4, 3)
      availability_zone_index = 1
      public_routing_enabled  = false
      tags                    = {}
    },
  ]

  private_subnets = [
    {
      name_prefix             = local.private_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host2}/24", 4, 4)
      availability_zone_index = 0
      public_routing_enabled  = false
      tags = {
        "kubernetes.io/role/internal-elb" = "1"
      }
    },
    {
      name_prefix             = local.private_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host2}/24", 4, 5)
      availability_zone_index = 1
      public_routing_enabled  = false
      tags = {
        "kubernetes.io/role/internal-elb" = "1"
      }
    },
    {
      name_prefix             = local.private_subnet_name_prefix
      cidr_block              = cidrsubnet("${local.cidr_host2}/24", 4, 6)
      availability_zone_index = 2
      public_routing_enabled  = false
      tags = {
        "kubernetes.io/role/internal-elb" = "1"
      }
    },
  ]
  vpc_config = {
    cidr_block = var.cidr_block
    public_subnets = [
      {
        cidr_block = cidrsubnet("${local.cidr_host}/18", 4, 0)
        tags = {
          "kubernetes.io/role/elb" = "1"
        }
      },
      {
        cidr_block = cidrsubnet("${local.cidr_host}/18", 4, 1)
        tags = {
          "kubernetes.io/role/elb" = "1"
        }
      },
      {
        cidr_block = cidrsubnet("${local.cidr_host}/18", 4, 2)
        tags = {
          "kubernetes.io/role/elb" = "1"
        }
      },
    ]
    private_subnets = concat(
      local.eks1_nodes_subnets,
      local.eks1_cluster_subnets,
      local.eks2_nodes_subnets,
      local.eks2_cluster_subnets,
      local.private_subnets
    )
  }


  requester_peering_subnets = [
    for pair in setproduct(local.vpc_config.private_subnets, var.vpc_peering_config_requester) : {
      key                       = "${pair[1].name}-${pair[0].name_prefix}-${pair[0].availability_zone_index}"
      route_table_id            = aws_route_table.private["${pair[0].name_prefix}-${pair[0].availability_zone_index}"].id
      destination_cidr_block    = pair[1].destination_cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.this[pair[1].name].id
    }
  ]

  accepter_peering_subnets = [
    for pair in setproduct(local.vpc_config.private_subnets, var.vpc_peering_config_accepter) : {
      key                       = "${pair[1].name}-${pair[0].name_prefix}-${pair[0].availability_zone_index}"
      route_table_id            = aws_route_table.private["${pair[0].name_prefix}-${pair[0].availability_zone_index}"].id
      destination_cidr_block    = pair[1].destination_cidr_block
      vpc_peering_connection_id = data.aws_vpc_peering_connection.this[pair[1].name].id
    }
  ]
}

resource "aws_vpc" "this" {
  cidr_block           = local.vpc_config.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.global_tags
}

resource "aws_internet_gateway" "this" {
  for_each = {
    for s in ["internet"] :
    s => s
    if length(local.vpc_config.public_subnets) != 0
  }

  vpc_id = aws_vpc.this.id

  tags = local.global_tags
}

# public subnets with NAT
resource "aws_subnet" "public" {
  for_each = {
    for idx, subnet in local.vpc_config.public_subnets :
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
      Name = each.key,
    },
  )
}

resource "aws_eip" "public" {
  for_each = {
    for idx, subnet in local.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  vpc = true

  tags = merge(
    local.global_tags,
    {
      Name = each.key
    },
  )
}

resource "aws_nat_gateway" "public" {
  for_each = {
    for idx, subnet in local.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  allocation_id = aws_eip.public[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    local.global_tags,
    {
      Name = each.key
    },
  )
}

resource "aws_route_table" "public" {
  for_each = {
    for idx, subnet in local.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.global_tags,
    {
      Name = each.key
    },
  )
}

resource "aws_route" "public" {
  for_each = {
    for idx, subnet in local.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this["internet"].id
}

resource "aws_route_table_association" "public" {
  for_each = {
    for idx, subnet in local.vpc_config.public_subnets :
    "${local.public_subnet_name_prefix}-${idx}" => subnet
  }

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

# Private subnets with egress routing through NAT
resource "aws_subnet" "private" {
  for_each = {
    for subnet in local.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = data.aws_availability_zones.available.names[each.value.availability_zone_index]

  tags = merge(
    local.global_tags,
    each.value.tags,
    {
      Name = each.key,
    },
  )
}

resource "aws_route_table" "private" {
  for_each = {
    for subnet in local.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
  }

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.global_tags,
    {
      Name = each.key
    },
  )
}

resource "aws_route" "private" {
  for_each = {
    for subnet in local.vpc_config.private_subnets :
    "${subnet.name_prefix}-${subnet.availability_zone_index}" => subnet
    if subnet.public_routing_enabled
  }

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public["${local.public_subnet_name_prefix}-${each.value.availability_zone_index}"].id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for subnet in local.vpc_config.private_subnets :
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
      Name = each.key
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
