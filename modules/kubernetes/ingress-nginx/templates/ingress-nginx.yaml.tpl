
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: ${ingress_nginx_name}
  namespace: ingress-nginx
spec:
  interval: 1m0s
  url: "https://kubernetes.github.io/ingress-nginx"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: ${ingress_nginx_name}
  namespace: ingress-nginx
spec:
  chart:
    spec:
      chart: ingress-nginx
      sourceRef:
        kind: HelmRepository
        name: ${ingress_nginx_name}
      version: 4.12.1
  interval: 1m0s
  values:
    controller:
      image:
        chroot: true
      replicaCount: ${replicas}
      minAvailable: ${min_replicas}
      resources:
        requests:
          cpu: 100m
          memory: 110Mi
      ingressClassResource:
        name: ${ingress_class}
        default: ${default_ingress_class}
        controllerValue: "k8s.io/ingress-${ingress_class}"
      priorityClassName: "platform-high"
      ingressClass: ${ingress_class}
      %{~ if private_ingress_enabled ~}
      electionID: ingress-controller-leader-${ingress_class}
      ingressClassByName: true
      %{~ endif ~}

      service:
        externalTrafficPolicy: "Local"
        %{~ if internal_load_balancer || external_dns_hostname != "" ~}
        annotations:
          %{~ if internal_load_balancer ~}
          service.beta.kubernetes.io/azure-load-balancer-internal: "true"
          %{~ endif ~}
          %{~ if external_dns_hostname != "" ~}
          external-dns.alpha.kubernetes.io/hostname: ${external_dns_hostname}
          %{~ endif ~}
        %{~ endif ~}
      allowSnippetAnnotations: ${allow_snippet_annotations}
      config:
        %{~ for key, value in extra_config ~}
        ${key}: "${value}"
        %{~ endfor ~}
        server-tokens: "false"
        %{~ if datadog_enabled ~}
        datadog-collector-host: "$HOST_IP"
        enable-opentracing: "true"
        %{~ endif ~}
        %{~ if http_snippet != "" ~}
        http-snippet: |
          ${http_snippet}
        %{~ endif ~}
        %{~ if allow_snippet_annotations ~}
        annotation-value-word-blocklist: load_module,lua_package,_by_lua,location,root,proxy_pass,serviceaccount,{,},',\
        %{~ endif ~}

      addHeaders:
        %{~ for key, value in extra_headers ~}
        ${key}: "${value}"
        %{~ endfor ~}

      %{~ if default_certificate.enabled ~}
      extraArgs:
        default-ssl-certificate: "${default_certificate.namespaced_name}"
      %{~ endif ~}

      %{~ if datadog_enabled || linkerd_enabled ~}
      podAnnotations:
        %{~ if datadog_enabled ~}
        ad.datadoghq.com/controller.check_names: '["nginx", "nginx_ingress_controller"]'
        ad.datadoghq.com/controller.init_configs: '[{},{}]'
        ad.datadoghq.com/controller.instances: '[{"prometheus_url": "http://%%host%%:%%port_metrics%%/metrics"}]'
        ad.datadoghq.com/controller.logs: '[{"service": "controller", "source": "nginx-ingress-controller"}]'
        %{~ endif ~}
        %{~ if linkerd_enabled ~}
        linkerd.io/inject: "ingress"
        # It's required to skip inbound ports for the ingress or whitelist of IPs won't work:
        # https://github.com/linkerd/linkerd2/issues/3334#issuecomment-565135188
        config.linkerd.io/skip-inbound-ports: "80,443,8443"
        %{~ endif ~}
      %{~ endif ~}
      %{~ if datadog_enabled ~}
      extraEnvs:
      - name: HOST_IP
        valueFrom:
          fieldRef:
            apiVersion: v1
            fieldPath: status.hostIP
      %{~ endif ~}

      metrics:
        enabled: true
        service:
          labels:
            function: metrics

      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchExpressions:
                    - key: app.kubernetes.io/instance
                      operator: In
                      values:
                        - ingress-${ingress_class}
                topologyKey: topology.kubernetes.io/zone
              weight: 100

      tolerations:
        - key: "kubernetes.azure.com/scalesetpriority"
          operator: "Equal"
          value: "spot"
          effect: "NoSchedule"

%{~ if default_certificate.enabled ~}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${ingress_nginx_name}
  namespace: ingress-nginx
spec:
  secretName: ${ingress_nginx_name}
  revisionHistoryLimit: 3
  dnsNames:
    - '*.${default_certificate.dns_zone}'
  issuerRef:
    kind: ClusterIssuer
    name: letsencrypt

%{~ endif ~}
%{~ if nginx_healthz_ingress_enabled ~}
---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-healthz
  namespace: ingress-nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    nginx.ingress.kubernetes.io/proxy-body-size: 50m
    nginx.ingress.kubernetes.io/whitelist-source-range: >-
      ${nginx_healthz_ingress_whitelist_ips}
spec:
  ingressClassName: nginx
  tls:
    - hosts:
      - "health.${nginx_healthz_ingress_hostname}"
      secretName: healthz-ingress-secret
  rules:
  - host: "health.${nginx_healthz_ingress_hostname}"
    http:
      paths:
      - path: /healthz
        pathType: Prefix
        backend:
          service:
            name: ingress-nginx-controller-metrics
            port:
              number: 10254
%{~ endif ~}