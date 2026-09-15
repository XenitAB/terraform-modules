apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: arc-runner-set-${runner_scale_set_name}
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: ${runners_namespace}
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: ghcr.io/actions/actions-runner-controller-charts
    targetRevision: ${chart_version}
    chart: gha-runner-scale-set
    helm:
      valuesObject:
        # This name is the `runs-on` label in the workflows. Changing it
        # silently strands every job that still asks for the old one.
        runnerScaleSetName: ${runner_scale_set_name}
        githubConfigUrl: ${github_config_url}

        # Secret produced by ESO from Key Vault; see external-secret-arc.yaml.
        githubConfigSecret: arc-github-app

        minRunners: ${min_runners}
        maxRunners: ${max_runners}

        # The listener runs in the controller's namespace, not here, so it
        # needs its own pass at the Gatekeeper constraints.
        listenerTemplate:
          spec:
            priorityClassName: platform-medium
            containers:
              - name: listener
                securityContext:
                  allowPrivilegeEscalation: false
                  readOnlyRootFilesystem: true
                  runAsNonRoot: true
                  runAsUser: 1000
                  capabilities:
                    drop: [ALL]
                resources:
                  requests:
                    cpu: 20m
                    memory: 64Mi
                  limits:
                    memory: 256Mi

        template:
          spec:
            # Runner pods execute arbitrary workflow code from the repository.
            # Keep them off the nodes that run the rest of the platform.
            priorityClassName: platform-low
            nodeSelector:
              node-pool: arc
            tolerations:
              - key: "node-pool"
                operator: "Equal"
                value: "arc"
                effect: "NoSchedule"
            containers:
              - name: runner
                image: ghcr.io/actions/actions-runner:2.337.0
                command: ["/home/runner/run.sh"]
                # No readOnlyRootFilesystem here: the runner unpacks the
                # workflow into /home/runner/_work and writes its registration
                # under its own install directory.
                securityContext:
                  allowPrivilegeEscalation: false
                  runAsNonRoot: true
                  runAsUser: 1000
                  capabilities:
                    drop: [ALL]
                resources:
                  requests:
                    cpu: 500m
                    memory: 1Gi
                  limits:
                    memory: 4Gi
