resource "aws_kms_key" "this" {
  description         = "eks secrets cmk"
  enable_key_rotation = true
}
