apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: falco
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
    namespace: falco
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
  source:
    repoURL: https://falcosecurity.github.io/charts
    targetRevision: 9.1.0
    chart: falco
    helm:
      valuesObject:
        # Pinned rather than left at the chart's "auto" so the driver cannot
        # change under us. modern_ebpf (CO-RE) uses a single BPF ring buffer
        # instead of per-CPU mmap'd perf buffers, which avoids
        #   "unable to mmap the perf-buffer for cpu 'N': Cannot allocate memory"
        # on nodes with many CPUs and a low RLIMIT_MEMLOCK. Falco 0.44 removed
        # the legacy BPF probe, so the only alternatives left are kmod and auto.
        driver:
          kind: ${driver_kind}
        # falcoctl installs the rulesets as OCI artifacts into an emptyDir that
        # the chart mounts over /etc/falco, so every rules file Falco reads comes
        # from here - falco_rules.yaml included, which is why it must stay in refs
        # even though the image bakes a copy of it. The chart's containerPlugin
        # helper appends the container plugin ref and "plugin" to allowedTypes on
        # its own whenever collectors.containerEngine is enabled, so
        # /usr/share/falco/plugins is populated by falcoctl as well.
        # The three rulesets version independently of one another. falco-rules
        # tracks the Falco release - 5.1.0 is exactly what the 0.44.1 image bakes
        # in, same layer digest as cmake/modules/rules.cmake pins - while the
        # incubating and sandbox rulesets are on their own major.
        # NOTE FOR CHART BUMPS: these three refs are tied to the chart's Falco
        # version and do not move on their own. When targetRevision above changes
        # - including when tf-latest-version raises it automatically - check the
        # new image's cmake/modules/rules.cmake for the falco-rules version it
        # bakes in and pick the incubating/sandbox majors that declare the same
        # required_engine_version. Leaving them behind loads a ruleset the engine
        # may reject, or one whose macro names have drifted again.
        # follow is off: with exact pins there is nothing to follow, and a sidecar
        # that re-resolves refs on its own schedule can move the loaded ruleset
        # out from under git. Its refs are kept in sync regardless, so turning it
        # on later cannot silently drop back to the stable-only ruleset.
        falcoctl:
          artifact:
            install:
              enabled: true
            follow:
              enabled: false
          config:
            artifact:
              install:
                resolveDeps: false
                refs:
                  - falco-rules:5.1.0
                  - falco-incubating-rules:6.0.1
                  - falco-sandbox-rules:6.1.0
              follow:
                refs:
                  - falco-rules:5.1.0
                  - falco-incubating-rules:6.0.1
                  - falco-sandbox-rules:6.1.0
        falco:
          # Listed explicitly because the chart default covers only
          # falco_rules.yaml, and every exception macro below except
          # user_known_contact_k8s_api_server_activities and
          # user_known_read_sensitive_files_activities belongs to a rule in the
          # incubating or sandbox ruleset. Order matters: rules.d carries our
          # overrides and must load last so it replaces the upstream
          # (never_true) definitions rather than being replaced by them.
          # falco_rules.local.yaml is omitted - the emptyDir over /etc/falco
          # means it no longer exists, and Falco silently skips missing entries.
          rules_files:
            - /etc/falco/falco_rules.yaml
            - /etc/falco/falco-incubating_rules.yaml
            - /etc/falco/falco-sandbox_rules.yaml
            - /etc/falco/rules.d
          # The falco image ships /etc/falco/config.d/falco.container_plugin.yaml,
          # which also sets `load_plugins: [container]`. The default "append"
          # merge strategy concatenates it with the chart's own value, so the
          # container plugin gets registered twice and Falco aborts at startup:
          #   "cannot register plugin ... found another plugin with name container"
          # add-only makes this rendered config authoritative; the image fragment
          # can still add keys we don't set, but never duplicate ours.
          # With falcoctl enabled the emptyDir over /etc/falco hides that fragment
          # outright and Falco skips the missing directory, so this is kept only
          # as a guard for the case where falcoctl is turned back off.
          config_files:
            - path: /etc/falco/config.d
              strategy: add-only
          # ISO8601 is pinned here instead of inherited from the image fragment,
          # which is no longer reachable; the chart default is false and would
          # move log timestamps out of ISO8601.
          time_format_iso_8601: true
          # Falco's built-in Prometheus metrics endpoint, replacing the
          # deprecated falco-exporter (archived upstream July 2025).
          webserver:
            prometheus_metrics_enabled: true
          json_output: true
          json_include_output_property: true
          json_include_tags_property: true
          # This should be further explored in the future but seems
          # to be a bug right now with no fix so the solution is sadly
          # to ignore all syscall errors.
          # https://github.com/falcosecurity/falco/issues/1403
          # The key is syscall_event_drops, not syscallEventDrops - the camelCase
          # spelling this module used before was not a valid Falco key, so the
          # suppression never applied and the default actions [log, alert] stayed
          # in effect.
          syscall_event_drops:
            actions:
              - log
            rate: 0.03333
            max_burst: 1
        # Native Falco metrics, scraped directly off the falco pods.
        # interval is the internal stats refresh rate; 15m is upstream's
        # lowest production-recommended value (chart default 1h is too
        # coarse for rule-hit alerting).
        metrics:
          enabled: true
          interval: 15m
          # preserves the previous falco.metrics.output_rule: true
          outputRule: true
        podPriorityClassName: platform-high
        scc:
          # -- Create OpenShift's Security Context Constraint.
          create: false
        podSecurityContext:
          runAsNonRoot: false
        resources:
          requests:
            cpu: 100m
            memory: 512Mi
          limits:
            cpu: 1000m
            memory: 1024Mi
        collectors:
          containerEngine:
            # AKS nodes run containerd; no docker or podman socket exists there.
            # The collectors.docker / collectors.crio keys this module set before
            # no longer exist in chart 9.x - engines.* replaced them. crio has no
            # switch of its own any more: it shares the "cri" engine with
            # containerd, and turning that off would blind the container plugin,
            # which every exception macro below depends on for
            # container.image.repository.
            engines:
              docker:
                enabled: false
              podman:
                enabled: false
        # -- Tolerations to allow Falco to run on Kubernetes masters.
        tolerations:
          - effect: NoSchedule
            key: node-role.kubernetes.io/master
          - effect: NoSchedule
            key: node-role.kubernetes.io/control-plane
          - operator: Exists
        # Exception macros. Every name here must match an item that one of the
        # loaded rulesets actually references, otherwise Falco logs
        # LOAD_UNUSED_MACRO at startup and the exception silently does nothing.
        # Upstream defines each of them as `condition: (never_true)` purely as an
        # extension point, and each is negated (`and not ...`) in its rule, so
        # redefining one here narrows detection rather than widening it.
        customRules:
          # Applications which are expected to communicate with the Kubernetes API
          # (rule "Contact K8S API Server From Container", stable ruleset)
          rules_user_known_k8s_api_callers.yaml: |-
            - macro: user_known_contact_k8s_api_server_activities
              condition: >
                (container.image.repository in (
                  "ghcr.io/xenitab/git-auth-proxy",
                  "docker.io/grafana/loki",
                  "grafana/fluent-bit-plugin-loki",
                  "ghcr.io/xenitab/azad-kube-proxy",
                  "cr.l5d.io/linkerd/controller",
                  "cr.l5d.io/linkerd/proxy",
                  "mcr.microsoft.com/oss/azure/workload-identity/proxy-init",
                  "quay.io/jetstack/cert-manager-cainjector",
                  "quay.io/jetstack/cert-manager-controller",
                  "quay.io/jetstack/cert-manager-webhook",
                  "docker.io/bitnami/external-dns",
                  "registry.k8s.io/external-dns/external-dns",
                  "squat/configmap-to-disk",
                  "stakater/reloader",
                  "gcr.io/datadoghq/agent",
                  "quay.io/prometheus/prometheus",
                  "quay.io/prometheus-operator/prometheus-operator",
                  "registry.k8s.io/ingress-nginx/controller",
                  "gcr.io/datadoghq/cluster-agent",
                  "registry.k8s.io/sig-storage/csi-node-driver-registrar",
                  "openpolicyagent/gatekeeper",
                  "quay.io/fairwinds/goldilocks",
                  "registry.k8s.io/autoscaling/vpa-recommender",
                  "registry.k8s.io/autoscaling/vpa-admission-controller",
                  "registry.k8s.io/autoscaling/vpa-updater",
                  "docker.io/giantswarm/starboard-exporter",
                  "docker.io/aquasec/trivy-operator",
                  "ghcr.io/aquasecurity/trivy-operator",
                  "registry.k8s.io/autoscaling/cluster-autoscaler",
                  "quay.io/argoproj/argocd-application-controller",
                  "quay.io/argoproj/argocd-applicationset-controller",
                  "quay.io/argoproj/argocd-repo-server",
                  "registry.k8s.io/kube-state-metrics/kube-state-metrics",
                  "ghcr.io/fluxcd/kustomize-controller",
                  "ghcr.io/fluxcd/helm-controller",
                  "ghcr.io/fluxcd/source-controller",
                  "ghcr.io/fluxcd/notification-controller"
                ))
          # Applications which spawn a docker or kubectl client
          # Kustomize controller runs kubectl and kustomize
          # Tunnel front is expected to do this
          # https://github.com/Azure/AKS/issues/2087
          # (rule "Kubernetes Client Tool Launched in Container", sandbox ruleset)
          rules_user_known_k8s_client_container.yaml: |-
            - macro: user_known_k8s_client_container
              condition: >
                (container.image.repository in (
                  "mcr.microsoft.com/aks/hcp/hcp-tunnel-front",
                  "ghcr.io/fluxcd/kustomize-controller",
                  "ghcr.io/fluxcd/helm-controller",
                  "quay.io/argoproj/argocd-repo-server"
                ))
          # Sensitive mounts in containers
          # AKS uses a different kube-proxy image
          # Node exporter has to mount sensitive paths
          # (rule "Launch Sensitive Mount Container", sandbox ruleset)
          rules_user_sensitive_mount_containers.yaml: |-
            - macro: user_sensitive_mount_containers
              condition: >
                (container.image.repository in (
                  "mcr.microsoft.com/oss/kubernetes/kube-proxy",
                  "quay.io/prometheus/node-exporter",
                  "gcr.io/datadoghq/agent",
                  "docker.io/falcosecurity/falco",
                  "registry.k8s.io/sig-storage/csi-node-driver-registrar"
                ))
          # AKS tunnelfront writes in /etc
          # (rule "Write below etc", sandbox ruleset)
          # The rule's condition negates two hooks, user_known_write_etc_conditions
          # and user_known_write_below_etc_activities. We use the latter: upstream
          # labels it "a placeholder for user to extend the whitelist" and defaults
          # it to (never_true), so redefining it is purely additive. The former
          # defaults to (proc.name=confd), so overriding that one would silently
          # drop the confd exemption.
          rules_user_known_write_below_etc_activities.yaml: |-
            - macro: user_known_write_below_etc_activities
              condition: >
                (container.image.repository in (
                  "mcr.microsoft.com/aks/hcp/hcp-tunnel-front",
                  "gcr.io/datadoghq/agent",
                  "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver"
                ))
          # System components that are expected to run privileged
          # (rule "Launch Privileged Container", incubating ruleset)
          rules_user_privileged_containers.yaml: |-
            - macro: user_privileged_containers
              condition: >
                (container.image.repository in (
%{ if !cilium_enabled ~}
                  "mcr.microsoft.com/oss/calico/node",
%{ endif ~}
                  "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver",
                  "mcr.microsoft.com/oss/kubernetes-csi/azuredisk-csi",
                  "mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi",
                  "mcr.microsoft.com/oss/kubernetes/kube-proxy",
                  "registry.k8s.io/sig-storage/csi-node-driver-registrar",
                  "registry.k8s.io/dns/k8s-dns-node-cache",
                  "docker.io/falcosecurity/falco",
                  "quay.io/prometheus/node-exporter"
                ))
          # System binaries that legitimately talk to the network
          # (rule "System procs network activity", incubating ruleset)
          rules_user_expected_system_procs_network_activity_conditions.yaml: |-
            - macro: user_expected_system_procs_network_activity_conditions
              condition: >
                (container.image.repository in (
                  "gcr.io/datadoghq/agent",
                  "quay.io/prometheus/node-exporter",
                  "registry.k8s.io/ingress-nginx/controller"
                ))
          # Package management exceptions (apt, yum, apk)
          # (rule "Launch Package Management Process in Container", incubating)
          rules_user_known_package_manager_in_container.yaml: |-
            - macro: user_known_package_manager_in_container
              condition: >
                (container.image.repository in (
                  "gcr.io/datadoghq/agent"
                ))
          # Init containers that spawn a shell below a non-shell parent.
          # user_shell_container_exclusions is the image-oriented hook for the
          # rule; user_known_shell_spawn_binaries, which this used to be called,
          # is a list of parent process names and cannot express an image.
          # (rule "Run shell untrusted", stable ruleset)
          rules_user_shell_container_exclusions.yaml: |-
            - macro: user_shell_container_exclusions
              condition: >
                (container.image.repository in (
                  "mcr.microsoft.com/oss/azure/workload-identity/proxy-init",
                  "cr.l5d.io/linkerd/proxy-init"
                ))
          # Service account token access exceptions
          # (rule "Read sensitive file untrusted", stable ruleset)
          rules_user_known_read_sensitive_files_activities.yaml: |-
            - macro: user_known_read_sensitive_files_activities
              condition: >
                (container.image.repository in (
                  "gcr.io/datadoghq/agent",
                  "quay.io/prometheus/prometheus"
                ))
