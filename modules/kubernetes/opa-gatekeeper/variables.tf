variable "default_constraints" {
  description = "Default constraints that should be added"
  type = list(object({
    kind       = string
    name       = string
    parameters = any
  }))
  default = [
    {
      kind       = "K8sPSPAllowPrivilegeEscalationContainer"
      name       = "psp-allow-privilege-escalation-container"
      parameters = {}
    },
    {
      kind       = "K8sPSPHostNamespace"
      name       = "psp-host-namespace"
      parameters = {}
    },
    {
      kind       = "K8sPSPHostNetworkingPorts"
      name       = "psp-host-network-ports"
      parameters = {}
    },
    {
      kind       = "K8sPSPFlexVolumes"
      name       = "psp-flexvolume-drivers"
      parameters = {}
    },
    {
      kind       = "K8sPSPPrivilegedContainer"
      name       = "psp-privileged-container"
      parameters = {}
    },
    {
      kind       = "K8sPSPProcMount"
      name       = "psp-proc-mount"
      parameters = {}
    },
    {
      kind       = "K8sPSPReadOnlyRootFilesystem"
      name       = "psp-readonlyrootfilesystem"
      parameters = {}
    },
    {
      kind = "K8sPSPVolumeTypes"
      name = "psp-volume-types"
      parameters = {
        volumes = ["configMap", "downwardAPI", "emptyDir", "persistentVolumeClaim", "secret", "projected"]
      }
    },
    {
      kind = "K8sPSPCapabilities"
      name = "psp-capabilities"
      parameters = {
        allowedCapabilities = [""]
      }
    },
  ]
}

variable "additional_constraints" {
  description = "Additional constraints that should be added"
  type = list(object({
    kind       = string
    name       = string
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
