# Globally shared values across all sub charts
global:
  lowDataMode: true
  cluster: ${cluster_name}
  licenseKey: ${license_key}

infrastructure:
  enabled: false
webhook:
  enabled: false
prometheus:
  enabled: true
ksm:
  enabled: true
kubeEvents:
  enabled: true
logging:
  enabled: true

newrelic-logging:
  priorityClassName: platform-high
  fluentBit:
    path: ${fluent_bit_path}

nri-prometheus:
  priorityClassName: platform-low

nri-kube-events:
  priorityClassName: platform-low
