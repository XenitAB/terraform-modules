variable "default_constraints" {
  description = "Default constraints that should be added"
  type = list(object({
    kind = string
    name = string
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
      kind = "K8sPSPAllowPrivilegeEscalationContainer"
      name = "psp-allow-privilege-escalation-container"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sPSPHostNamespace"
      name = "psp-host-namespace"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sPSPHostNetworkingPorts"
      name = "psp-host-network-ports"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sPSPFlexVolumes"
      name = "psp-flexvolume-drivers"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sPSPPrivilegedContainer"
      name = "psp-privileged-container"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sPSPProcMount"
      name = "psp-proc-mount"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sPSPReadOnlyRootFilesystem"
      name = "psp-readonlyrootfilesystem"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sPSPVolumeTypes"
      name = "psp-volume-types"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {
        volumes = ["configMap", "downwardAPI", "emptyDir", "persistentVolumeClaim", "secret", "projected"]
      }
    },
    {
      kind = "K8sPSPCapabilities"
      name = "psp-capabilities"
      match = {
        kinds = [
          {
            apiGroups = [""]
            kinds     = ["Pod"]
          }
        ]
        namespaces = ["*"]
      }
      parameters = {
        allowedCapabilities = [""]
      }
    },
    {
      kind = "K8sBlockNodePort"
      name = "block-node-port"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind = "K8sRequiredProbes"
      name = "required-probes"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {
        probes     = ["readinessProbe"]
        probeTypes = ["tcpSocket", "httpGet", "exec"]
      }
    },
    {
      kind = "K8sPodPriorityClass"
      name = "pod-priority-class"
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
    kind = string
    name = string
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
