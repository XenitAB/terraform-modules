crds:
  keep: true

redis-ha:
  enabled: true

controller:
  env:
    - name: ARGOCD_CONTROLLER_REPLICAS
      value: "${controller_min_replicas}"
  podLabels:
    azure.workload.identity/use: "true" 
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: "${client_id}"
      azure.workload.identity/tenant-id: "${tenant_id}"
  replicas: ${controller_min_replicas}
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
  autoscaling:
    enabled: true
    minReplicas: ${repo_server_min_replicas}
  env:
    - name: ARGOCD_GIT_ATTEMPTS_COUNT
      value: "3"

applicationSet:
  replicas: ${application_set_replicas}

global:
  domain: ${global_domain}
  # Do we want to be able to run argo on system pool or spot instances?
  # tolerations: 

server:
  autoscaling:
    enabled: true
    minReplicas: ${server_min_replicas}
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      cert-manager.io/cluster-issuer: "letsencrypt"
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      nginx.ingress.kubernetes.io/limit-whitelist: "${ingress_whitelist_ip}"
    extraTls:
      - hosts:
        - ${global_domain}
        secretName: argocd-tls
  log:
    level: debug
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
      ignoreResourceStatusField: crd
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
    controller.operation.processors: "25"
    # Number of application status processors (default 20)
    controller.status.processors: "50"
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
    server.insecure: "false"
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