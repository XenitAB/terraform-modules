resource "aws_route53_zone" "this" {
  name = var.dns_zone

  for_each = {
    for s in ["zone"] :
    s => s
    if var.dns_zone_enabled
  }

  tags = merge(
    {
      Name        = var.dns_zone
    },
    local.global_tags
  )
}
