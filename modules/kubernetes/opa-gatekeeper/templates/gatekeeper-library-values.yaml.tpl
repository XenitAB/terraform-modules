constraints:
  - kind: K8sPSPAllowPrivilegeEscalationContainer
    name: psp-allow-privilege-escalation-container
  - kind: K8sPSPHostNamespace
    name: psp-host-namespace
  - kind: K8sPSPHostNetworkingPorts
    name: psp-host-network-ports
  - kind: K8sPSPFlexVolumes
    name: psp-flexvolume-drivers
  - kind: K8sPSPPrivilegedContainer
    name: psp-privileged-container
  - kind: K8sPSPProcMount
    name: psp-proc-mount
  - kind: K8sPSPReadOnlyRootFilesystem
    name: psp-readonlyrootfilesystem
