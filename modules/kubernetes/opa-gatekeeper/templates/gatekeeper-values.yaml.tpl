postInstall:
  labelNamespace:
    enabled: false
  tolerations:
    - key: "kubernetes.azure.com/scalesetpriority"
      operator: "Equal"
      value: "spot"
      effect: "NoSchedule"
controllerManager:
  %{~ if provider == "aws" ~}
  hostNetwork: true
  port: 8010
  metricsPort: 8011
  healthPort: 8012
  %{~ endif ~}
  priorityClassName: platform-high
  tolerations:
    - key: "kubernetes.azure.com/scalesetpriority"
      operator: "Equal"
      value: "spot"
      effect: "NoSchedule"
audit:
  priorityClassName: platform-high
  resources:
    limits:
      memory: 750Mi
    requests:
      cpu: 100m
      memory: 256Mi
  tolerations:
    - key: "kubernetes.azure.com/scalesetpriority"
      operator: "Equal"
      value: "spot"
      effect: "NoSchedule"
  %{~ if provider == "aws" ~}
  hostNetwork: true
  metricsPort: 8013
  healthPort: 8014
  %{~ endif ~}
psp:
  enabled: false
upgradeCRDs:
  enabled: false
mutatingWebhookReinvocationPolicy: IfNeeded

mutatingWebhookCustomRules:
  - apiGroups:
    - '*'
    apiVersions:
    - '*'
    operations:
    - CREATE
    - UPDATE
    resources:
    - '*'
    - pods/ephemeralcontainers
    scope: '*'

