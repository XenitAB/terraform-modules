apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: prometheus
  namespace: prometheus
spec:
  podMetricsEndpoints:
    - port: web
  selector:
    matchLabels:
      app.kubernetes.io/name: prometheus
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: cert-manager
  namespace: cert-manager
spec:
  endpoints:
  - interval: 60s
    path: /metrics
    scrapeTimeout: 30s
    targetPort: 9402
  jobLabel: cert-manager
  namespaceSelector:
    matchNames:
    - cert-manager
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/instance: cert-manager
      app.kubernetes.io/name: cert-manager
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  endpoints:
  - interval: 30s
    port: metrics
  namespaceSelector:
    matchNames:
    - ingress-nginx
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/name: ingress-nginx
      function: metrics
%{ if cilium_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: cilium
  namespace: prometheus
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      k8s-app: cilium
  podMetricsEndpoints:
    - path: /metrics
      port: prometheus
  podTargetLabels:
  - k8s-app
  namespaceSelector:
    matchNames:
      - kube-system
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: cilium-operator
  namespace: prometheus
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      name: cilium-operator
  podMetricsEndpoints:
    - path: /metrics
      port: prometheus
  podTargetLabels:
  - io.cilium/app
  namespaceSelector:
    matchNames:
      - kube-system
%{ endif }
%{ if aad_pod_identity_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: aad-pod-identity-mic
  namespace: aad-pod-identity
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app.kubernetes.io/instance: aad-pod-identity
      app.kubernetes.io/name: aad-pod-identity
      app.kubernetes.io/component: mic
  podMetricsEndpoints:
    - path: /metrics
      port: metrics
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: aad-pod-identity-nmi
  namespace: aad-pod-identity
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app.kubernetes.io/instance: aad-pod-identity
      app.kubernetes.io/name: aad-pod-identity
      app.kubernetes.io/component: nmi
  podMetricsEndpoints:
    - path: /metrics
      port: metrics
%{ endif }
%{ if flux_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: helm-controller
  namespace: flux-system
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app: helm-controller
  podMetricsEndpoints:
    - port: http-prom
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: kustomize-controller
  namespace: flux-system
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app: kustomize-controller
  podMetricsEndpoints:
    - port: http-prom
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: notification-controller
  namespace: flux-system
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app: notification-controller
  podMetricsEndpoints:
    - port: http-prom
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: source-controller
  namespace: flux-system
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app: source-controller
  podMetricsEndpoints:
    - port: http-prom
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: git-auth-proxy
  namespace: flux-system
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  endpoints:
  - interval: 30s
    port: metrics
  namespaceSelector:
    matchNames:
    - flux-system
  selector:
    matchLabels:
      app.kubernetes.io/instance: git-auth-proxy
      app.kubernetes.io/name: git-auth-proxy
%{ endif }
%{ if falco_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: falco-exporter
  namespace: falco
spec:
  endpoints:
  - interval: 30s
    port: metrics
  namespaceSelector:
    matchNames:
    - falco
  selector:
    matchLabels:
      app.kubernetes.io/instance: falco-exporter
      app.kubernetes.io/name: falco-exporter
%{ endif }
%{ if gatekeeper_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: gatekeeper-audit
  namespace: gatekeeper-system
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app: gatekeeper
      control-plane: audit-controller
  podMetricsEndpoints:
    - port: metrics
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: gatekeeper-controller-manager
  namespace: gatekeeper-system
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app: gatekeeper
      control-plane: controller-manager
  podMetricsEndpoints:
    - port: metrics
%{ endif }
%{ if linkerd_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: linkerd-federate
  namespace: linkerd-viz
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  endpoints:
  - interval: 30s
    scrapeTimeout: 30s
    params:
      match[]:
      - '{job="linkerd-proxy"}'
      - '{job="linkerd-controller"}'
    path: /federate
    port: admin-http
    honorLabels: true
    relabelings:
    - action: keep
      regex: '^prometheus$'
      sourceLabels:
      - '__meta_kubernetes_pod_container_name'
  jobLabel: app
  namespaceSelector:
    matchNames:
    - linkerd-viz
  selector:
    matchLabels:
      component: prometheus
%{ endif }
%{ if azad_kube_proxy_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: azad-kube-proxy
  namespace: azad-kube-proxy
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app.kubernetes.io/instance: azad-kube-proxy
      app.kubernetes.io/name: azad-kube-proxy
  podMetricsEndpoints:
    - path: /metrics
      port: metrics
%{ endif }
%{ if trivy_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: starboard-exporter
  namespace: trivy
spec:
  endpoints:
  - interval: 1m
    path: /metrics
    port: metrics
  namespaceSelector:
    matchNames:
    - trivy
  selector:
    matchLabels:
      app.kubernetes.io/instance: starboard-exporter
      app.kubernetes.io/name: starboard-exporter
%{ endif }
%{ if grafana_agent_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: grafana-agent
  namespace: grafana-agent
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: grafana-agent
  podMetricsEndpoints:
    - port: http-metrics
%{ endif }
%{ if node_local_dns_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: node-local-dns
  namespace: prometheus
spec:
  endpoints:
    - interval: 60s
      path: /metrics
      scrapeTimeout: 30s
      targetPort: 9253
  namespaceSelector:
    matchNames:
      - kube-system
  selector:
    matchLabels:
      k8s-app: node-local-dns
%{ endif }
%{ if promtail_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: promtail
  namespace: promtail
spec:
  endpoints:
    - port: http-metrics
      interval: 60s
      path: /metrics
      scrapeTimeout: 30s
  namespaceSelector:
    matchNames:
    - promtail
  selector:
    matchLabels:
      app.kubernetes.io/instance: promtail
      app.kubernetes.io/name: promtail
%{ endif }
%{ if node_ttl_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: node-ttl
  namespace: node-ttl
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: node-ttl
      app.kubernetes.io/instance: node-ttl
  endpoints:
    - port: metrics
%{ endif }
%{ if spegel_enabled }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: spegel
  namespace: spegel
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: spegel
      app.kubernetes.io/instance: spegel
  endpoints:
    - port: metrics
%{ endif }
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: platform
  name: x509-certificate-exporter
  namespace: prometheus
spec:
  endpoints:
    - port: metrics
      interval: 60s
      path: /metrics
      scrapeTimeout: 30s
      metricRelabelings:
        - action: labeldrop
          regex: serial_number|issuer_CN|secret_key|secret_namespace|service|pod|instance|container
  namespaceSelector:
    matchNames:
    - prometheus
  selector:
    matchLabels:
      app.kubernetes.io/instance: x509-certificate-exporter
      app.kubernetes.io/name: x509-certificate-exporter
