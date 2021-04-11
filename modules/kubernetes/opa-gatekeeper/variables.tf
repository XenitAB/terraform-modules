variable "enable_default_constraints" {
  description = "If enabled default constraints will be added"
  type        = bool
  default     = true
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

variable "enable_default_assigns" {
  description = "If enabled default assigns will be added"
  type        = bool
  default     = true
}

variable "additional_assigns" {
  description = "Additional assigns that should be added"
  type = list(object({
    name = string
  }))
  default = []
}

variable "excluded_namespaces" {
  description = "Namespaces to opt out of constraints and assigns"
  type        = list(string)
  default     = ["kube-system", "gatekeeper-system"]
}
