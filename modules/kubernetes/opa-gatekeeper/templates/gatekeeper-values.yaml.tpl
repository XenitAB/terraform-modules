postInstall:
  labelNamespace:
    enabled: false
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
  resources:
    limits:
      memory: 750Mi
    requests:
      cpu: 100m
      memory: 256Mi
  %{~ if provider == "aws" ~}
  hostNetwork: true
  metricsPort: 8013
  healthPort: 8014
  %{~ endif ~}
psp:
  enabled: false
upgradeCRDs:
  enabled: false
