priorityClassName: "platform-low"
podSecurityPolicy:
  enabled: false
metricLabelsAllowlist:
  - "namespaces=[xkf.xenit.io/kind]"
namespaces: ${namespaces_csv}
collectors:
  # Disable collection of configmaps and secrets to reduce amount of metrics
  #- configmaps
  #- secrets
  - certificatesigningrequests
  - cronjobs
  - daemonsets
  - deployments
  - endpoints
  - horizontalpodautoscalers
  - ingresses
  - jobs
  - limitranges
  - mutatingwebhookconfigurations
  - namespaces
  - networkpolicies
  - nodes
  - persistentvolumeclaims
  - persistentvolumes
  - poddisruptionbudgets
  - pods
  - replicasets
  - replicationcontrollers
  - resourcequotas
  - services
  - statefulsets
  - storageclasses
  - validatingwebhookconfigurations
  - volumeattachments
# Specificly add verticalpodautoscalers to collectors
%{ if vpa_enabled }
  - verticalpodautoscalers # not a default resource, see also: https://github.com/kubernetes/kube-state-metrics#enabling-verticalpodautoscalers
%{ endif }
prometheus:
  monitor:
    enabled: true
    additionalLabels:
      xkf.xenit.io/monitoring: tenant
