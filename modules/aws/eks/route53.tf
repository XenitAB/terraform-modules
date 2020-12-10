resource "aws_route53_zone" "dns" {
  name = var.dnsZone

  tags = {
    Name = var.dnsZone
  }
}
