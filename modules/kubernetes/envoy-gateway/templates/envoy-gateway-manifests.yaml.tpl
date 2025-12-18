apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: envoy-gateway-clienttrafficpolicy-requirements
  annotations:
    policies.kyverno.io/title: Require TLS in ClientTrafficPolicy
    policies.kyverno.io/category: Envoy Gateway
    policies.kyverno.io/severity: high
    policies.kyverno.io/subject: ClientTrafficPolicy
    policies.kyverno.io/description: >-
      This policy ensures that all ClientTrafficPolicy resources include a TLS block
      and properly configured targetRefs pointing to Gateway resources.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: require-tls-block
      match:
        any:
          - resources:
              kinds:
                - ClientTrafficPolicy
              operations:
                - CREATE
                - UPDATE
      validate:
        message: "ClientTrafficPolicy must include a 'tls' block in its spec."
        pattern:
          spec:
            tls: "?*"
    - name: require-gateway-targetrefs
      match:
        any:
          - resources:
              kinds:
                - ClientTrafficPolicy
              operations:
                - CREATE
                - UPDATE
      validate:
        message: "ClientTrafficPolicy must include a 'targetRefs' block in its spec with kind 'Gateway' and group 'gateway.networking.k8s.io'."
        pattern:
          spec:
            targetRefs:
              - group: gateway.networking.k8s.io
                kind: Gateway
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: envoy-gateway-set-client-ip-detection
  annotations:
    policies.kyverno.io/title: Set Client IP Detection for ClientTrafficPolicy
    policies.kyverno.io/category: Envoy Gateway
    policies.kyverno.io/subject: ClientTrafficPolicy
    policies.kyverno.io/description: >-
      This policy automatically sets clientIPDetection configuration with xForwardedFor
      and 2 trusted hops for all ClientTrafficPolicy resources.
spec:
  background: false
  rules:
    - name: set-client-ip-detection
      match:
        any:
          - resources:
              kinds:
                - ClientTrafficPolicy
              operations:
                - CREATE
                - UPDATE
      mutate:
        patchStrategicMerge:
          spec:
            clientIPDetection:
              xForwardedFor:
                numTrustedHops: 2
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: envoy-gateway-set-tls-ciphers
  annotations:
    policies.kyverno.io/title: Set TLS Ciphers and Version for ClientTrafficPolicy
    policies.kyverno.io/category: Envoy Gateway
    policies.kyverno.io/severity: high
    policies.kyverno.io/subject: ClientTrafficPolicy
    policies.kyverno.io/description: >-
      This policy automatically configures secure TLS cipher suites and minimum TLS version
      for all ClientTrafficPolicy resources to ensure strong encryption standards.
spec:
  background: false
  rules:
    - name: set-tls-configuration
      match:
        any:
          - resources:
              kinds:
                - ClientTrafficPolicy
              operations:
                - CREATE
                - UPDATE
      mutate:
        patchStrategicMerge:
          spec:
            tls:
              ciphers:
                - ECDHE-ECDSA-AES128-GCM-SHA256
                - ECDHE-ECDSA-CHACHA20-POLY1305
                - ECDHE-RSA-AES128-GCM-SHA256
                - ECDHE-RSA-CHACHA20-POLY1305
                - ECDHE-ECDSA-AES256-GCM-SHA384
                - ECDHE-RSA-AES256-GCM-SHA384
              minVersion: "1.2"
