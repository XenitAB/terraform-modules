postInstall:
  labelNamespace:
    enabled: false
experimentalEnableMutation: true
controllerManager:
  %{ if provider == "aws" }
  hostNetwork: true
  %{ endif }
  priorityClassName: platform-high
audit:
  priorityClassName: platform-high
  %{ if provider == "aws" }
  hostNetwork: true
  %{ endif }
