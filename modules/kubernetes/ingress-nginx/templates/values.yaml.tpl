controller:
  replicaCount: 3

  priorityClassName: platform-medium

  ingressClass: ${ingress_class}

  # https://github.com/kubernetes/ingress-nginx/issues/5593#issuecomment-647538272
  ingressClassResource:
    enabled: true
    default: ${default_ingress_class}

  %{~ if provider == "aws" ~}
  # Optionally change this to ClusterFirstWithHostNet in case you have 'hostNetwork: true'.
  # By default, while using host network, name resolution uses the host's DNS. If you wish nginx-controller
  # to keep resolving names inside the k8s network, use ClusterFirstWithHostNet.
  dnsPolicy: ClusterFirstWithHostNet
  hostNetwork: true
  %{~ endif ~}

  service:
    externalTrafficPolicy: Local
    %{~ if provider == "aws" || internal_load_balancer ~}
    annotations:
      %{~ if internal_load_balancer ~}
      service.beta.kubernetes.io/${provider}-load-balancer-internal: "true"
      %{~ endif ~}
      %{~ if provider == "aws" ~}
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
      %{~ endif ~}
    %{~ endif ~}

  config:
    %{~ for key, value in extra_config ~}
    ${key}: "${value}"
    %{~ endfor ~}
    server-tokens: "false"
    use-forwarded-headers: "true"
    %{~ if datadog_enabled ~}
    datadog-collector-host: "$HOST_IP"
    enable-opentracing: "true"
    %{~ endif ~}
    %{~ if http_snippet != "" ~}
    http-snippet: |
      ${http_snippet}
    %{~ endif ~}
    allow-snippet-annotations: ${allow_snippet_annotations}
    %{~ if !allow_snippet_annotations ~}
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
    ad.datadoghq.com/controller.check_names: '["nginx_ingress_controller"]'
    ad.datadoghq.com/controller.init_configs: '[{}]'
    ad.datadoghq.com/controller.instances: '[{"prometheus_url": "http://%%host%%:%%port_metrics%%/metrics"}]'
    %{~ endif ~}
    %{~ if linkerd_enabled ~}
    linkerd.io/inject: "ingress"
    # It's required to skip inbound ports for the ingress or whitelist of IPs won't work:
    # https://github.com/linkerd/linkerd2/issues/3334#issuecomment-565135188
    config.linkerd.io/skip-inbound-ports: "80,443"
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
  %{~ if provider == "aws" && internal_load_balancer ~}
    port: 10354

  containerPort:
    http: 1080
    https: 1443

  admissionWebhooks:
    port: 2443

  extraArgs:
    # Port to use for the healthz endpoint. (default 10254)
    healthz-port: 10354
    http-port: 1080
    https-port: 1443
    # Port to use for exposing the default server (catch-all). (default 8181)
    default-server-port: 8282
    # Port to use for expose the ingress controller Go profiler when it is enabled. (default 10245)
    profiler-port: 10345
    # Port to use for the lua HTTP endpoint configuration. (default 10246)
    status-port: 10346
    # Port to use for the lua TCP/UDP endpoint configuration. (default 10247)
    stream-port: 10347

  livenessProbe:
    httpGet:
      port: 10354
  readinessProbe:
    httpGet:
      port: 10354
  %{~ endif ~}

  affinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - podAffinityTerm:
            labelSelector:
              matchExpressions:
                - key: app.kubernetes.io/name
                  operator: In
                  values:
                    - ingress-nginx
            topologyKey: topology.kubernetes.io/zone
          weight: 100
