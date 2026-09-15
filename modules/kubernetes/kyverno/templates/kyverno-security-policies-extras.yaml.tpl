apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-loadbalancer-services
  annotations:
    policies.kyverno.io/title: Disallow LoadBalancer Services
    policies.kyverno.io/category: Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      LoadBalancer services expose workloads directly to the internet. This policy
      prevents the use of LoadBalancer services to enforce traffic routing through
      ingress controllers.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: disallow-loadbalancer
    match:
      any:
      - resources:
          kinds:
          - Service
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
    validate:
      message: "Services of type LoadBalancer are not allowed"
      pattern:
        spec:
          type: "!LoadBalancer"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-wildcard-ingress
  annotations:
    policies.kyverno.io/title: Disallow Wildcard Ingress
    policies.kyverno.io/category: Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Ingress resources should not use wildcard hostnames as they can intercept traffic
      for all hostnames in the cluster. This policy blocks Ingress resources that use
      a wildcard (*) as the hostname.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: disallow-wildcard-hostname
    match:
      any:
      - resources:
          kinds:
          - Ingress
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
    validate:
      message: "Wildcard (*) hostname in Ingress is not allowed"
      deny:
        conditions:
          any:
          - key: "{{ request.object.spec.rules[?host == '*'] | length(@) }}"
            operator: GreaterThan
            value: 0
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-unique-csi-volumes
  annotations:
    policies.kyverno.io/title: Require Unique CSI SecretProviderClass
    policies.kyverno.io/category: Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Each secrets-store CSI volume must reference a unique secretProviderClass to
      prevent unintended secret sharing between volumes. This policy enforces that
      no two CSI volumes in a Pod use the same secretProviderClass.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: unique-secret-provider-class
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
    preconditions:
      all:
      - key: "{{ request.object.spec.volumes[?csi && csi.driver == 'secrets-store.csi.k8s.io'] | length(@) }}"
        operator: GreaterThan
        value: 0
    validate:
      message: "Each secrets-store CSI volume must use a unique secretProviderClass"
      deny:
        conditions:
          any:
          - key: "{{ request.object.spec.volumes[?csi && csi.driver == 'secrets-store.csi.k8s.io'].csi.volumeAttributes.secretProviderClass | length(@) }}"
            operator: NotEquals
            value: "{{ request.object.spec.volumes[?csi && csi.driver == 'secrets-store.csi.k8s.io'].csi.volumeAttributes.secretProviderClass | unique(@) | length(@) }}"
