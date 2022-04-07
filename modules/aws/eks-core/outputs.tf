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


output "dns_zones" {
  description = "The zone id and names of the dns zones that we create"
  value = {
    for dns in aws_route53_zone.this :
    dns.name => dns.zone_id
  }
}
