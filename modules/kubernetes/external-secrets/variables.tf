variable "aws_config" {
  description = "AWS specific configuration"
  type = object({
    role_arn = string,
    region   = string
  })
  default = {
    role_arn = "",
    region   = ""
  }
}
