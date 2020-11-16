variable "exclude_namespaces" {
  description = "Namespaces to opt out of constraints"
  type = list(string)
  default = ["kube-system", "gatekeeper-system"]
}
