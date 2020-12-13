variable "default_constraints" {
  description = "Default constraints that should be added"
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
  default = [
    {
      kind               = "K8sPSPAllowPrivilegeEscalationContainer"
      name               = "psp-allow-privilege-escalation-container"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPSPHostNamespace"
      name               = "psp-host-namespace"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPSPHostNetworkingPorts"
      name               = "psp-host-network-ports"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPSPFlexVolumes"
      name               = "psp-flexvolume-drivers"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPSPPrivilegedContainer"
      name               = "psp-privileged-container"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPSPProcMount"
      name               = "psp-proc-mount"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPSPReadOnlyRootFilesystem"
      name               = "psp-readonlyrootfilesystem"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPSPVolumeTypes"
      name               = "psp-volume-types"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {
        volumes = ["configMap", "downwardAPI", "emptyDir", "persistentVolumeClaim", "secret", "projected", "csi"]
      }
    },
    {
      kind               = "K8sPSPCapabilities"
      name               = "psp-capabilities"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {
        allowedCapabilities      = [""]
        requiredDropCapabilities = ["NET_RAW"]
      }
    },
    {
      kind               = "K8sBlockNodePort"
      name               = "block-node-port"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "K8sPodPriorityClass"
      name               = "pod-priority-class"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    # FIXES https://github.com/kubernetes/kubernetes/issues/97076
    {
      kind               = "K8sExternalIPs"
      name               = "external-ips"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
  ]
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
