# Azure storage account to use
azure:
  storageAccount: 
    location: ${location}
    resourceGroup: ${resource_group_name}
    name: ${storage_account_name}
    key: ${storage_account_key}
  pvc:
    size: ${file_share_size}
# Popeye spinach configuration
config:
  popeye:
    allocations:
      cpu:
        overPercUtilization: 100
        underPercUtilization: 50
      memory:
        overPercUtilization: 100
        underPercUtilization: 50
    # Excludes excludes certain resources from Popeye scans
    excludes:
      global:
        # excludes all resources in kube-system, kube-public, etc..
        fqns: 
        - default
        - rx:^kube-
        # Eclude XKS platform components
        labels:
          xkf.xenit.io/kind: 
          - platform
    resources:
      node:
        limits:
          cpu:    90
          memory: 80
      pod:
        limits:
          cpu:    80
          memory: 75
        restarts:
          5
    %{~ if length(allowed_registries) > 0 ~}
    registries:
      %{~ for registry in allowed_registries ~}
      - ${registry}
      %{~ endfor ~}
    %{~ endif ~}
# The Popeye CronJob
cronJobs:
  image: derailed/popeye:v0.21.5
  namespaces:
    %{~ for job in cron_jobs ~}
    - name: ${job.namespace}
      scan: ${job.resources}
      schedule: ${job.schedule}
      format: ${job.output_format}
    %{~ endfor ~}
  resources:
    limits:
      cpu: 500m
      memory: 100Mi
# Workload identity
identity:
  # Client id
  id: ${client_id}
# RBAC
rbac:
  create: true