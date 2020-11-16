variable "default_constraints" {
  description = "Default constraints that should be added"
  type = list(object({
    kind = string
    name = string
  }))
  default = [
    {
      kind = "K8sPSPAllowPrivilegeEscalationContainer"
      name = "psp-allow-privilege-escalation-container"
    },
    {
      kind = "K8sPSPHostNamespace"
      name = "psp-host-namespace"
    },
    {
      kind = "K8sPSPHostNetworkingPorts"
      name = "psp-host-network-ports"
    },
    {
      kind = "K8sPSPFlexVolumes"
      name = "psp-flexvolume-drivers"
    },
    {
      kind = "K8sPSPPrivilegedContainer"
      name = "psp-privileged-container"
    },
    {
      kind = "K8sPSPProcMount"
      name = "psp-proc-mount"
    },
    {
      kind = "K8sPSPReadOnlyRootFilesystem"
      name = "psp-readonlyrootfilesystem"
    },
  ]
}

variable "additional_constraints" {
  description = "Additional constraints that should be added"
  type = list(object({
    kind = string
    name = string
  }))
  default = []
}

variable "exclude_namespaces" {
  description = "Namespaces to opt out of constraints"
  type = list(string)
  default = ["kube-system", "gatekeeper-system"]
}
