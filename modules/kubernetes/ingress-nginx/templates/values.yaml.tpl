controller:
  image:
    chroot: true

  replicaCount: 3
  minAvailable: 2

  resources:
    requests:
      cpu: 100m
      memory: 110Mi

  priorityClassName: platform-high

  ingressClassResource:
    name: ${ingress_class}
    default: ${default_ingress_class}
    controllerValue: "k8s.io/ingress-${ingress_class}"

  # Should eventually be removed as ingress class annotations are deprecated
  ingressClass: ${ingress_class}

  %{~ if public_private_enabled ~}
  electionID: ingress-controller-leader-${ingress_class}
  ingressClassByName: true
  %{~ endif ~}

  service:
    externalTrafficPolicy: Local
    %{~ if internal_load_balancer || external_dns_hostname != "" ~}
    annotations:
      %{~ if internal_load_balancer ~}
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
      %{~ endif ~}
      %{~ if external_dns_hostname != "" ~}
      external-dns.alpha.kubernetes.io/hostname: ${external_dns_hostname}
      %{~ endif ~}
    %{~ endif ~}

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
    allow-snippet-annotations: ${allow_snippet_annotations}
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
