resource "aws_route53_zone" "this" {
  name = var.dns_zone

  for_each = {
    for s in ["zone"] :
    s => s
    if var.dns_zone_enabled
  }

  tags = merge(
    local.global_tags,
    {
      Name        = var.dns_zone
    },
  )
}
