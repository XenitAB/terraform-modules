---
# GatewayClass - Defines the controller that will manage Gateway resources
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  controllerName: gateway.envoyproxy.io/gatewayclass-controller
  description: "${tenant_name} ${environment} gateway class managed by Xenit"
---
# ConstraintTemplate for validating TLS configuration
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: clienttrafficpolicytlsgatewaycheck
spec:
  crd:
    spec:
      names:
        kind: ClientTrafficPolicyTLSGatewayCheck
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: "package clienttrafficpolicy\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  not spec_has_tls(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must include a 'tls' block in its spec.\"\n}\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  not spec_has_target_refs(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must include a 'targetRefs' block in its spec with the required 'group' and 'kind.'\"\n}\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  spec_has_weak_tls(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must use TLS 1.2 or higher.\"\n}\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  spec_has_weak_ciphers(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must not use weak or deprecated cipher suites.\"\n}\n\nspec_has_tls(spec) {\n  spec.tls != null\n}\n\nspec_has_target_refs(spec) {\n  targetRefs := spec.targetRefs\n  targetRefs[_].group == \"gateway.networking.k8s.io\"\n  targetRefs[_].kind == \"Gateway\"\n}\n\nspec_has_weak_tls(spec) {\n  spec.tls.minVersion\n  weak_versions := [\"1.0\", \"1.1\"]\n  weak_versions[_] == spec.tls.minVersion\n}\n\nspec_has_weak_ciphers(spec) {\n  spec.tls.ciphers\n  weak_ciphers := [\"DES\", \"3DES\", \"RC4\", \"MD5\", \"NULL\", \"EXPORT\", \"anon\"]\n  cipher := spec.tls.ciphers[_]\n  contains(cipher, weak_ciphers[_])\n}\n\ncontains(str, substr) {\n  indexof(str, substr) != -1\n}\n"
---
# Assign mutation for client IP detection
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: envoy-gateway-set-client-ip-detection
spec:
  applyTo:
    - groups: ["gateway.envoyproxy.io"]
      versions: ["v1alpha1"]
      kinds: ["ClientTrafficPolicy"]
  location: "spec.clientIPDetection"
  match:
    kinds:
      - apiGroups: ["gateway.envoyproxy.io"]
        kinds: ["ClientTrafficPolicy"]
  parameters:
    assign:
      value:
        xForwardedFor:
          numTrustedHops: 2
---
# Assign mutation for TLS configuration
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: envoy-gateway-set-tls
spec:
  applyTo:
    - groups: ["gateway.envoyproxy.io"]
      versions: ["v1alpha1"]
      kinds: ["ClientTrafficPolicy"]
  location: "spec.tls"
  match:
    kinds:
      - apiGroups: ["gateway.envoyproxy.io"]
        kinds: ["ClientTrafficPolicy"]
  parameters:
    assign:
      value:
        minVersion: '1.2'
        maxVersion: '1.3'
        ciphers:
          # TLS 1.3 ciphers (preferred)
          - TLS_AES_128_GCM_SHA256
          - TLS_AES_256_GCM_SHA384
          - TLS_CHACHA20_POLY1305_SHA256
          # TLS 1.2 ciphers (fallback)
          - ECDHE-ECDSA-AES128-GCM-SHA256
          - ECDHE-ECDSA-CHACHA20-POLY1305
          - ECDHE-RSA-AES128-GCM-SHA256
          - ECDHE-RSA-CHACHA20-POLY1305
          - ECDHE-ECDSA-AES256-GCM-SHA384
          - ECDHE-RSA-AES256-GCM-SHA384
        ecdhCurves:
          - X25519
          - P-256
          - P-384
---
# Assign mutation for connection limits
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: envoy-gateway-set-connection-limits
spec:
  applyTo:
    - groups: ["gateway.envoyproxy.io"]
      versions: ["v1alpha1"]
      kinds: ["ClientTrafficPolicy"]
  location: "spec.connection"
  match:
    kinds:
      - apiGroups: ["gateway.envoyproxy.io"]
        kinds: ["ClientTrafficPolicy"]
  parameters:
    assign:
      value:
        bufferLimit: 32Ki
        connectionLimit:
          value: 10000
          closeDelay: 10s
---
# Assign mutation for HTTP/2 limits
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: envoy-gateway-set-http2-limits
spec:
  applyTo:
    - groups: ["gateway.envoyproxy.io"]
      versions: ["v1alpha1"]
      kinds: ["ClientTrafficPolicy"]
  location: "spec.http2"
  match:
    kinds:
      - apiGroups: ["gateway.envoyproxy.io"]
        kinds: ["ClientTrafficPolicy"]
  parameters:
    assign:
      value:
        initialStreamWindowSize: 65536
        initialConnectionWindowSize: 1048576
        maxConcurrentStreams: 100
---
# PodDisruptionBudget for high availability
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: envoy-gateway-pdb
  namespace: envoy-gateway
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: envoy-gateway
---
# PodDisruptionBudget for Envoy proxy pods
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: envoy-proxy-pdb
  namespace: envoy-gateway
spec:
  minAvailable: 1
  selector:
    matchLabels:
      gateway.envoyproxy.io/owning-gateway-name: default-gateway
