apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gatekeeper
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/compare-options: IncludeMutationWebhook=true
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "-1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: gatekeeper-system
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  ignoreDifferences:
  - group: admissionregistration.k8s.io
    kind: MutatingWebhookConfiguration
    name: gatekeeper-mutating-webhook-configuration
    jqPathExpressions:
    - .metadata.generation
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "control-plane")
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "kubernetes.azure.com/managedby")
  - group: admissionregistration.k8s.io
    kind: ValidatingWebhookConfiguration
    name: gatekeeper-validating-webhook-configuration
    jqPathExpressions:
    - .metadata.generation
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "control-plane")
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "kubernetes.azure.com/managedby")
  source:
    repoURL: https://open-policy-agent.github.io/gatekeeper/charts
    targetRevision: 3.18.2
    chart: gatekeeper
    helm:
      valuesObject:
        postInstall:
          labelNamespace:
            enabled: false
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"
        controllerManager:
          priorityClassName: platform-high
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"
        audit:
          priorityClassName: platform-high
          resources:
            limits:
              memory: 750Mi
            requests:
              cpu: 100m
              memory: 256Mi
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"
        psp:
          enabled: false
        upgradeCRDs:
          enabled: false
        mutatingWebhookReinvocationPolicy: IfNeeded
        mutatingWebhookCustomRules:
          - apiGroups:
            - '*'
            apiVersions:
            - '*'
            operations:
            - CREATE
            - UPDATE
            resources:
            - '*'
            - pods/ephemeralcontainers
            scope: '*'
