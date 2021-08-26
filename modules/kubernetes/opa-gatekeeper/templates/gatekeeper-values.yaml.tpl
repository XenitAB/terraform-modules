postInstall:
  labelNamespace:
    enabled: false
experimentalEnableMutation: true
controllerManager:
  %{~ if provider == "aws" ~}
  hostNetwork: true
  port: 8010
  metricsPort: 8011
  healthPort: 8012
  %{~ endif ~}
  priorityClassName: platform-high
audit:
  priorityClassName: platform-high
  %{~ if provider == "aws" ~}
  hostNetwork: true
  metricsPort: 8013
  healthPort: 8014
  %{~ endif ~}
