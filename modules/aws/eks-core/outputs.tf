output "vpc_id" {
  description = "The id of the VPC created by this module"
  value       = aws_vpc.this.id
}

output "private_subnets_ids" {
  description = "The ids of the of private subnets created by this module"
  value = [
    for subnet in aws_subnet.private :
    subnet.id
    if contains(local.private_subnets.*.cidr_block, subnet.cidr_block)
  ]
}

