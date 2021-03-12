variable "enable_default_constraints" {
  description = "If enabled default constraints will be added"
  type = bool
  default = true
}

variable "additional_constraints" {
  description = "Additional constraints that should be added"
  type = list(object({
    kind               = string
    name               = string
    enforcement_action = string
    match = object({
      kinds = list(object({
        apiGroups = list(string)
        kinds     = list(string)
      }))
      namespaces = list(string)
    })
    parameters = any
  }))
  default = []
}

variable "exclude" {
  description = "Namespaces to opt out of constraints"
  type = list(object({
    excluded_namespaces = list(string)
    processes           = list(string)
  }))
  default = [
    {
      excluded_namespaces = ["kube-system", "gatekeeper-system"]
      processes           = ["*"]
    }
  ]
}
