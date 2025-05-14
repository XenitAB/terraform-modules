apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- gotk-sync.yaml
- gotk-components.yaml
patches:
  - patch: |-
      - op: replace
        path: /spec/url
        value: ${url}
      - op: replace
        path: /spec/secretRef/name
        value: flux-system
    target:
      group: source.toolkit.fluxcd.io
      version: v1
      kind: GitRepository
      name: flux-system
  - patch: |-
      apiVersion: v1
      kind: Namespace
      metadata:
        name: flux-system
        labels:
          xkf.xenit.io/kind: "platform"
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: source-controller
        namespace: flux-system
        labels:
          azure.workload.identity/use: "true"
      spec:
        template:
          metadata:
            labels:
              azure.workload.identity/use: "true"
          spec:
            priorityClassName: platform-medium
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: kustomize-controller
        namespace: flux-system
      spec:
        template:
          spec:
            priorityClassName: platform-medium
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: helm-controller
        namespace: flux-system
      spec:
        template:
          spec:
            priorityClassName: platform-medium
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: notification-controller
        namespace: flux-system
      spec:
        template:
          spec:
            priorityClassName: platform-medium
            containers:
              - name: manager
                args:
                  - '--rate-limit-interval=30m'
                  - '--watch-all-namespaces=true'
                  - '--log-level=info'
                  - '--log-encoding=json'
                  - '--enable-leader-election'
  - patch: |-
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        name: source-controller
        namespace: flux-system
        annotations:
          azure.workload.identity/client-id: ${client_id}
        labels:
          zure.workload.identity/use: "true"
