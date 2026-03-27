apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-nodeport-services
  annotations:
    policies.kyverno.io/title: Disallow NodePort Services
    policies.kyverno.io/category: Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      A ClusterIP service is only accessible from within the cluster, whereas NodePort
      and LoadBalancer services are accessible from outside the cluster. This policy
      prevents the use of NodePort services.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: disallow-nodeport
    match:
      any:
      - resources:
          kinds:
          - Service
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "gatekeeper-system"
          - "kyverno"
          - "flux-system"
          - "cert-manager"
          - "datadog"
          - "linkerd"
          - "external-dns"
          - "falco"
          - "trivy"
          - "vpa"
          - "kube-node-lease"
          - "kube-public"
    validate:
      message: "Services of type NodePort are not allowed"
      pattern:
        spec:
          type: "!NodePort"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-external-ips
  annotations:
    policies.kyverno.io/title: Disallow External IPs
    policies.kyverno.io/category: Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Service external IPs can be used for a MITM attack (CVE-2020-8554). This policy
      disallows the use of external IPs in Services.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: disallow-external-ips
    match:
      any:
      - resources:
          kinds:
          - Service
    validate:
      message: "Services with external IPs are not allowed"
      pattern:
        spec:
          X(externalIPs): "null"

---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-privileged-containers
  annotations:
    policies.kyverno.io/title: Disallow Privileged Containers
    policies.kyverno.io/category: Pod Security Standards (Restricted)
    policies.kyverno.io/severity: high
    policies.kyverno.io/description: >-
      Privileged containers share namespaces with the host system and do not offer
      any security. They should be disallowed.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-privileged
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "gatekeeper-system"
          - "kyverno"
          - "flux-system"
          - "cert-manager"
          - "datadog"
          - "linkerd"
          - "external-dns"
          - "falco"
          - "trivy"
          - "vpa"
          - "kube-node-lease"
          - "kube-public"
    validate:
      message: "Privileged containers are not allowed"
      pattern:
        spec:
          =(securityContext):
            =(privileged): "false"
          containers:
          - name: "*"
            =(securityContext):
              =(privileged): "false"
          =(initContainers):
          - name: "*"
            =(securityContext):
              =(privileged): "false"
          =(ephemeralContainers):
          - name: "*"
            =(securityContext):
              =(privileged): "false"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-host-namespaces
  annotations:
    policies.kyverno.io/title: Disallow Host Namespaces
    policies.kyverno.io/category: Pod Security Standards (Baseline)
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Host namespaces (Process ID namespace, Inter-Process Communication namespace, and
      network namespace) allow access to shared information and can be used to elevate
      privileges. Pods should not be allowed access to host namespaces.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-host-namespaces
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "gatekeeper-system"
          - "kyverno"
          - "flux-system"
          - "cert-manager"
          - "datadog"
          - "prometheus"
          - "linkerd"
          - "external-dns"
          - "falco"
          - "trivy"
          - "vpa"
          - "kube-node-lease"
          - "kube-public"
    validate:
      message: "Sharing the host namespaces is disallowed"
      pattern:
        spec:
          =(hostNetwork): "false"
          =(hostIPC): "false"
          =(hostPID): "false"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-host-networking-ports
  annotations:
    policies.kyverno.io/title: Disallow Host Networking and Ports
    policies.kyverno.io/category: Pod Security Standards (Baseline)
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Host networking allows access to the host's network namespace. Host networking
      should be disallowed.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-host-network
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "gatekeeper-system"
          - "kyverno"
          - "flux-system"
          - "cert-manager"
          - "datadog"
          - "prometheus"
          - "linkerd"
          - "external-dns"
          - "falco"
          - "trivy"
          - "vpa"
          - "kube-node-lease"
          - "kube-public"
    validate:
      message: "Host networking is not allowed"
      pattern:
        spec:
          =(hostNetwork): "false"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-proc-mount
  annotations:
    policies.kyverno.io/title: Disallow procMount
    policies.kyverno.io/category: Pod Security Standards (Baseline)
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      The default /proc masks are set up to reduce attack surface and should be required.
      This policy ensures nothing but the default procMount can be specified.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-proc-mount
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "gatekeeper-system"
          - "kyverno"
          - "flux-system"
          - "cert-manager"
          - "datadog"
          - "prometheus"
          - "linkerd"
          - "external-dns"
          - "falco"
          - "trivy"
          - "vpa"
          - "kube-node-lease"
          - "kube-public"
    validate:
      message: "Changing the proc mount from the default is not allowed"
      pattern:
        spec:
          =(securityContext):
            =(procMount): "Default"
          containers:
          - name: "*"
            =(securityContext):
              =(procMount): "Default"
          =(initContainers):
          - name: "*"
            =(securityContext):
              =(procMount): "Default"
          =(ephemeralContainers):
          - name: "*"
            =(securityContext):
              =(procMount): "Default"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: restrict-volume-types
  annotations:
    policies.kyverno.io/title: Restrict Volume Types
    policies.kyverno.io/category: Pod Security Standards (Restricted)
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      The restricted profile limits the allowed volume types. Only configMap, downwardAPI,
      emptyDir, persistentVolumeClaim, secret, projected, and csi volumes are allowed.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-volume-types
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "gatekeeper-system"
          - "kyverno"
          - "flux-system"
          - "cert-manager"
          - "datadog"
          - "prometheus"
          - "linkerd"
          - "external-dns"
          - "falco"
          - "trivy"
          - "vpa"
          - "kube-node-lease"
          - "kube-public"
    validate:
      message: "Volume type is not allowed. Only configMap, downwardAPI, emptyDir, persistentVolumeClaim, secret, projected, and csi volumes are permitted."
      deny:
        conditions:
          any:
          # Deny hostPath volumes
          - key: "{{ request.object.spec.volumes[?hostPath] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny nfs volumes
          - key: "{{ request.object.spec.volumes[?nfs] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny gitRepo volumes
          - key: "{{ request.object.spec.volumes[?gitRepo] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny awsElasticBlockStore volumes
          - key: "{{ request.object.spec.volumes[?awsElasticBlockStore] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny azureDisk volumes
          - key: "{{ request.object.spec.volumes[?azureDisk] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny azureFile volumes
          - key: "{{ request.object.spec.volumes[?azureFile] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny flexVolume volumes
          - key: "{{ request.object.spec.volumes[?flexVolume] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny gcePersistentDisk volumes
          - key: "{{ request.object.spec.volumes[?gcePersistentDisk] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny glusterfs volumes
          - key: "{{ request.object.spec.volumes[?glusterfs] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny iscsi volumes
          - key: "{{ request.object.spec.volumes[?iscsi] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny rbd volumes
          - key: "{{ request.object.spec.volumes[?rbd] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny cephFS volumes
          - key: "{{ request.object.spec.volumes[?cephFS] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny cinder volumes
          - key: "{{ request.object.spec.volumes[?cinder] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny fc volumes
          - key: "{{ request.object.spec.volumes[?fc] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny flocker volumes
          - key: "{{ request.object.spec.volumes[?flocker] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny photonPersistentDisk volumes
          - key: "{{ request.object.spec.volumes[?photonPersistentDisk] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny portworxVolume volumes
          - key: "{{ request.object.spec.volumes[?portworxVolume] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny quobyte volumes
          - key: "{{ request.object.spec.volumes[?quobyte] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny scaleIO volumes
          - key: "{{ request.object.spec.volumes[?scaleIO] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny storageos volumes
          - key: "{{ request.object.spec.volumes[?storageos] | length(@) }}"
            operator: GreaterThan
            value: 0
          # Deny vsphereVolume volumes
          - key: "{{ request.object.spec.volumes[?vsphereVolume] | length(@) }}"
            operator: GreaterThan
            value: 0
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-ingress-class
  annotations:
    policies.kyverno.io/title: Require Ingress Class
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/severity: low
    policies.kyverno.io/description: >-
      Ingress resources should specify an ingressClassName to ensure proper routing.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-ingress-class
    match:
      any:
      - resources:
          kinds:
          - Ingress
    validate:
      message: "Ingress must specify an ingressClassName"
      pattern:
        spec:
          ingressClassName: "?*"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-pod-priority-class
  annotations:
    policies.kyverno.io/title: Require Pod Priority Class
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Pods should specify a priorityClassName to ensure proper scheduling.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-priority-class
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "gatekeeper-system"
          - "kyverno"
          - "flux-system"
          - "cert-manager"
          - "datadog"
          - "prometheus"
          - "linkerd"
          - "external-dns"
          - "falco"
          - "trivy"
          - "vpa"
          - "kube-node-lease"
          - "kube-public"
    validate:
      message: "Pod must specify a priorityClassName from the allowed list"
      anyPattern:
      - spec:
          priorityClassName: "platform-high"
      - spec:
          priorityClassName: "platform-medium"
      - spec:
          priorityClassName: "platform-low"
      - spec:
          priorityClassName: "tenant-high"
      - spec:
          priorityClassName: "tenant-medium"
      - spec:
          priorityClassName: "tenant-low"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-insecure-security-context
  annotations:
    policies.kyverno.io/title: Disallow Insecure Security Contexts
    policies.kyverno.io/category: Security
    policies.kyverno.io/severity: high
    policies.kyverno.io/description: >
      This policy blocks Pods and higher-level controllers from running as root,
      allowing privilege escalation, or using privileged mode.
spec:
  validationFailureAction: Enforce  # change to "Audit" to test
  background: true
  rules:
    - name: disallow-root-and-privileged
      match:
        any:
          - resources:
              kinds:
                - Pod
                - Deployment
                - DaemonSet
                - StatefulSet
                - ReplicaSet
                - Job
                - CronJob
      exclude:
        any:
        - resources:
              namespaces:
              - "argocd"
              - "reloader"
              - "kube-system"
              - "gatekeeper-system"
              - "spegel"
              - "kyverno"
              - "flux-system"
              - "cert-manager"
              - "datadog"
              - "linkerd"
              - "external-dns"
              - "falco"
              - "trivy"
              - "vpa"
              - "kube-node-lease"
              - "kube-public"
      validate:
        message: >
          Running as root, allowing privilege escalation, running privileged
          containers, or not using readOnlyRootFilesystem is not allowed.
        pattern:
          spec:
            =(template):
              spec:
                containers:
                  - securityContext:
                      runAsNonRoot: true
                      allowPrivilegeEscalation: false
                      privileged: false
                      readOnlyRootFilesystem: true
                =(initContainers):
                  - securityContext:
                      runAsNonRoot: true
                      allowPrivilegeEscalation: false
                      privileged: false
                      readOnlyRootFilesystem: true
                =(ephemeralContainers):
                  - securityContext:
                      runAsNonRoot: true
                      allowPrivilegeEscalation: false
                      privileged: false
                      readOnlyRootFilesystem: true
            =(securityContext):
              runAsNonRoot: true
