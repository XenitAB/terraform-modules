variable "namespaces" {
  description = "Namespaces to apply mutating hooks to"
  type        = list(string)
}

variable "createSelfSignedCert" {
  description = "If true helm will generate a self signed cert"
  type = bool
  default = true
}
