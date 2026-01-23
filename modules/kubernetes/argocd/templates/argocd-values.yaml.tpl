crds:
  keep: true

redis:
  enabled: true
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

redis-ha:
  enabled: false
  replicas: 2
  haproxy:
    enabled: false
    metrics:
      enabled: true
      serviceMonitor:
        enabled: true

controller:
  replicas: ${controller_replicas}
  dynamicClusterDistribution: ${dynamic_sharding}
  env:
    - name: ARGOCD_ENABLE_K8S_EVENTS
      value: "none"
    - name: ARGOCD_K8S_CLIENT_QPS
      value: "${argocd_k8s_client_qps}"
    - name: ARGOCD_K8S_CLIENT_BURST
      value: "${argocd_k8s_client_burst}"
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  pdb:
    enabled: true
    minAvailable: 1
  podLabels:
    azure.workload.identity/use: "true" 
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: "${client_id}"
      azure.workload.identity/tenant-id: "${tenant_id}"
  volumes:
  - name: azure-federated-tokens
    projected:
      defaultMode: 420
      sources:
%{ for tenant in azure_tenants ~}
%{ for cluster in tenant.clusters ~}
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: ${tenant.tenant_name}-${cluster.environment}-federated-token-file
%{ endfor }
%{ endfor }
  volumeMounts:
  - mountPath: /var/run/secrets/tokens
    name: azure-federated-tokens
    readOnly: true

repoServer:
  replicas: ${repo_server_replicas}
  autoscaling:
    enabled: true
  env:
    - name: ARGOCD_GIT_ATTEMPTS_COUNT
      value: "3"
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

notifications:
  metrics:
    enabled: true

applicationSet:
  replicas: ${application_set_replicas}

global:
  domain: ${global_domain}
  # Do we want to be able to run argo on system pool or spot instances?
  # tolerations: 
  networkPolicy:
    create: true

server:
  replicas: ${server_replicas}
  autoscaling:
    enabled: true
  ingress:
    enabled: false
    ingressClassName: nginx
    annotations:
      cert-manager.io/cluster-issuer: "letsencrypt"
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      nginx.ingress.kubernetes.io/client-header-buffer-size: 256k
      nginx.ingress.kubernetes.io/large-client-header-buffers: 4 256k
      nginx.ingress.kubernetes.io/proxy-buffer-size: 16k
      nginx.ingress.kubernetes.io/limit-whitelist: "${ingress_whitelist_ip}"
    extraTls:
      - hosts:
        - ${global_domain}
        secretName: argocd-tls
  httproute:
  # -- Enable HTTPRoute resource for Argo CD server (Gateway API)
    enabled: true
    # -- Additional HTTPRoute labels
    labels: {}
    # -- Additional HTTPRoute annotations
    annotations: {}
    # -- Gateway API parentRefs for the HTTPRoute
    ## Must reference an existing Gateway
    # @default -- `[]` (See [values.yaml])
    parentRefs:
      - name: argocd-gateway
        namespace: argocd
        sectionName: https
    # -- List of hostnames for the HTTPRoute
    # @default -- `[]` (See [values.yaml])
    hostnames: 
      - ${global_domain}
      # - argocd.example.com
    # -- HTTPRoute rules configuration
    # @default -- `[]` (See [values.yaml])
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /
        # filters: []
        #   - type: RequestHeaderModifier
        #     requestHeaderModifier:
        #       add:
        #         - name: X-Custom-Header
        #           value: custom-value

  # Gateway API GRPCRoute configuration
  # NOTE: Gateway API support is in EXPERIMENTAL status
  # Support depends on your Gateway controller implementation
  # Refer to https://gateway-api.sigs.k8s.io/implementations/ for controller-specific details
  log:
    level: debug
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  podLabels:
    azure.workload.identity/use: "true" 
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: "${client_id}"
      azure.workload.identity/tenant-id: "${tenant_id}"
  volumes:
  - name: azure-federated-tokens
    projected:
      defaultMode: 420
      sources:
%{ for tenant in azure_tenants ~}
%{ for cluster in tenant.clusters ~}
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: ${tenant.tenant_name}-${cluster.environment}-federated-token-file
%{ endfor }
%{ endfor }
  volumeMounts:
  - mountPath: /var/run/secrets/tokens
    name: azure-federated-tokens
    readOnly: true

configs:
  cm:
    admin.enabled: false
    application.resourceTrackingMethod: annotation
    dex.config: |
      connectors:
      - type: microsoft
        id: microsoft
        name: Microsoft
        config:
          # Credentials can be string literals or pulled from the environment.
          clientID: ${dex_client_id}
          clientSecret: ${dex_client_secret}
          redirectURI: http://127.0.0.1:5556/dex/callback
          tenant: ${dex_tenant_name}
          groups:
            - ${aad_group_name}
    resource.compareoptions: |
      ignoreAggregatedRoles: true
      # disables status field diffing in specified resource types
      # 'crd' - CustomResourceDefinitions (default)
      # 'all' - all resources
      # 'none' - disabled
      ignoreResourceStatusField: all
    resource.customizations.health.argoproj.io_Application: |
      hs = {}
      hs.status = "Progressing"
      hs.message = ""
      if obj.status ~= nil then
        if obj.status.health ~= nil then
          hs.status = obj.status.health.status
          if obj.status.health.message ~= nil then
            hs.message = obj.status.health.message
          end
        end
      end
      return hs
    resource.exclusions: |
      - apiGroups:
        - "aadpodidentity.k8s.io"
        kinds:
        - AzureAssignedIdentity
        - AzureIdentity
        - AzureIdentityBinding
        - AzurePodIdentityException
      - apiGroups:
        - "acme.cert-manager.io"
        kinds:
        - Challenge
        - Order
      - apiGroups:
        - "aquasecurity.github.io"
        kinds:
        - ClusterSbomReport
        - ExposedSecretReport
        - SbomReport
        - VulnerabilityReport
      - apiGroups:
        - certificates.k8s.io
        kinds:
        - CertificateSigningRequest
      - apiGroups:
        - cert-manager.io
        kinds:
        - CertificateRequest
      - apiGroups:
        - cilium.io
        kinds:
        - CiliumIdentity
        - CiliumEndpoint
        - CiliumEndpointSlice
      - apiGroups:
        - ''
        - discovery.k8s.io
        kinds:
        - Endpoints
        - EndpointSlice

    # The maximum size of the payload that can be sent to the webhook server.
    webhook.maxPayloadSizeMB: "10"

  params:
    # Application reconciliation timeout is the sync interval
    timeout.reconciliation: 300s
    # The jitter is the maximum duration that can be added to the sync timeout,
    # allowing syncs to be spread out and not cause unwanted peaks
    timeout.reconciliation.jitter: "180s"
    # List of additional namespaces where applications may be created in and
    # reconciled from. The namespace where Argo CD is installed to will always
    # be allowed.
    application.namespaces: ${application_namespaces}
    # Enables the server side diff feature at the application controller level.
    # Diff calculation will be done by running a server side apply dryrun (when
    # diff cache is unavailable).
    controller.diff.server.side: "true"
    # Number of application operation processors (default 10)
    controller.operation.processors: "${controller_operation_processors}"
    # Number of application status processors (default 20)
    controller.status.processors: "${controller_status_processors}"
    # Specifies exponential backoff timeout parameters between application self heal attempts
    controller.self.heal.timeout.seconds: "5"
    controller.self.heal.backoff.factor: "3"
    controller.self.heal.backoff.cap.seconds: "300"
    # Specifies a sync timeout for applications. "0" means no timeout (default "0")
    controller.sync.timeout.seconds: "300"
    # Number of allowed concurrent kubectl fork/execs. Any value less than 1 means no limit.
    controller.kubectl.parallelism.limit: "20"
    # The maximum number of retries for each request
    controller.k8sclient.retry.max: "3"
    # The initial backoff delay on the first retry attempt in ms. Subsequent retries will double this backoff time up to a maximum threshold
    controller.k8sclient.retry.base.backoff: "200"
    # Grace period in seconds for ignoring consecutive errors while communicating with repo server.
    controller.repo.error.grace.period.seconds: "180s"
    # Limit on number of concurrent manifests generate requests. Any value less the 1 means no limit.
    reposerver.parallelism.limit: "100"
    # Number of concurrent git ls-remote requests. Any value less than 1 means no limit.
    reposerver.git.lsremote.parallelism.limit: "100"
    # Git requests timeout.
    reposerver.git.request.timeout: "15s"
    # Run server without TLS
    server.insecure: "true"
    # The maximum number of retries for each request
    server.k8sclient.retry.max: "3"
    # The initial backoff delay on the first retry attempt in ms. Subsequent retries will double this backoff time up to a maximum threshold
    server.k8sclient.retry.base.backoff: "200"
    # Number of webhook requests processed concurrently (default 50)
    server.webhook.parallelism.limit: "50"

  rbac:
    create: true
    policy.csv: |
      g, ${aad_group_name}, role:admin
