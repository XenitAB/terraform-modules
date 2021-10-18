prometheus:
  enabled: true
ksm:
  enabled: true
kubeEvents:
  enabled: true
logging:
  enabled: true

# Globally shared values across all sub charts
global:
  lowDataMode: true
  cluster: ${cluster_name}
  licenseKey: ${license_key}

newrelic-infrastructure:
  privileged: true
