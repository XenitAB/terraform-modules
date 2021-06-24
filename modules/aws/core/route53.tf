resource "aws_route53_zone" "this" {
  name = var.dns_zone

  tags = {
    Name        = var.dns_zone
    Environment = var.environment
  }
}
