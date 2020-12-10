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

variable "input_depends_on" {
  description = "Input dependency for module"
  type        = any
  default     = {}
}
