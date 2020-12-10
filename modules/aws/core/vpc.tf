resource "aws_vpc" "this" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_support   = var.vpc_config.enable_dns_support
  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames

  tags = {
    Name = var.name
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

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-default"
    Environment = var.environment
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.this.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

#resource "aws_subnet" "this" {
#  for_each = {
#    for subnet in var.vpcConfig.subnets :
#    subnet.name => subnet
#    if subnet.eksName == ""
#  }
#  vpc_id                  = aws_vpc.vpc.id
#  cidr_block              = each.value.cidr_block
#  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
#  map_public_ip_on_launch = true
#
#  tags = {
#    Name = "subnet-${var.environment}-${var.locationShort}-${var.commonName}-${each.value.name}"
#  }
#}

#resource "aws_subnet" "eks" {
#  for_each = {
#    for subnet in var.vpcConfig.subnets :
#    subnet.name => subnet
#    if subnet.eksName != ""
#  }
#  vpc_id                  = aws_vpc.vpc.id
#  cidr_block              = each.value.cidr_block
#  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
#  map_public_ip_on_launch = true
#
#
#  tags = {
#    "Name"                                                                                    = "subnet-${var.environment}-${var.locationShort}-${var.commonName}-${each.value.name}"
#    "kubernetes.io/cluster/eks-${var.environment}-${var.locationShort}-${each.value.eksName}" = "shared"
#  }
#}

#resource "aws_route_table_association" "subnet" {
#  for_each = {
#    for subnet in var.vpcConfig.subnets :
#    subnet.name => subnet
#    if subnet.eksName == ""
#  }
#
#  subnet_id      = aws_subnet.subnet[each.key].id
#  route_table_id = aws_route_table.rtDefault.id
#}
#
#resource "aws_route_table_association" "eks" {
#  for_each = {
#    for subnet in var.vpcConfig.subnets :
#    subnet.name => subnet
#    if subnet.eksName != ""
#  }
#
#  subnet_id      = aws_subnet.subnetEks[each.key].id
#  route_table_id = aws_route_table.rtDefault.id
#}
