resource "aws_route53_zone" "this" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
  }

  name = each.key

  tags = merge(
    local.global_tags,
    {
      Name = each.key
    },
  )
}
