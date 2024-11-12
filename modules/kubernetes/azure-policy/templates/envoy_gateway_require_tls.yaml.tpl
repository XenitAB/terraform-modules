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
      rego: "package clienttrafficpolicy\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  not spec_has_tls(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must include a 'tls' block in its spec.\"\n}\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  not spec_has_target_refs(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must include a 'targetRefs' block in its spec with the required 'group' and 'kind.'\"\n}\n\nspec_has_tls(spec) {\n  spec.tls != null\n}\n\nspec_has_target_refs(spec) {\n  targetRefs := spec.targetRefs\n  targetRefs[_].group == \"gateway.networking.k8s.io\"\n  targetRefs[_].kind == \"Gateway\"\n}\n"
    - target: admission.k8s.gatekeeper.sh

---
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
        ciphers:
          - ECDHE-ECDSA-AES128-GCM-SHA256
          - ECDHE-ECDSA-CHACHA20-POLY1305
          - ECDHE-RSA-AES128-GCM-SHA256
          - ECDHE-RSA-CHACHA20-POLY1305
          - ECDHE-ECDSA-AES256-GCM-SHA384
          - ECDHE-RSA-AES256-GCM-SHA384
        minVersion: '1.2'
