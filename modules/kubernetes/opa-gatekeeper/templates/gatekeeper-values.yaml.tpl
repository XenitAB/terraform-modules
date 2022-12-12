postInstall:
  labelNamespace:
    enabled: false
controllerManager:
  priorityClassName: platform-high
audit:
  priorityClassName: platform-high
  resources:
    limits:
      memory: 750Mi
    requests:
      cpu: 100m
      memory: 256Mi
psp:
  enabled: false
upgradeCRDs:
  enabled: false
mutatingWebhookReinvocationPolicy: IfNeeded
