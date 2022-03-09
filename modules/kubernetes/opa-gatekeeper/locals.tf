locals {
  default_assigns = [
    {
      name = "container-disallow-privilege-escalation"
    },
    {
      name = "container-drop-net-raw"
    },
    {
      name = "container-read-only-root-fs"
    },
    {
      name = "init-container-disallow-privilege-escalation"
    },
    {
      name = "init-container-drop-net-raw"
    },
    {
      name = "init-container-read-only-root-fs"
    }
  ]
  default_constraints = [
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
        requiredDropCapabilities = ["NET_RAW", "CAP_SYS_ADMIN"]
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
      kind               = "K8sRequiredProbes"
      name               = "required-probes"
      enforcement_action = "dryrun"
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
      kind               = "SecretsStoreCSIUniqueVolume"
      name               = "unique-volume"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "FluxRequireServiceAccount"
      name               = "require-service-account"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
    {
      kind               = "FluxDisableCrossNamespaceSource"
      name               = "disable-cross-namespace-source"
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
