apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: clienttrafficpolicytlsgatewaycheck
spec:
  crd:
    spec:
      names:
        kind: ClientTrafficPolicyTLSGatewayCheck   # <-- This is the kind we need to use in the constraint
  targets:
      rego: "package clienttrafficpolicy\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  not spec_has_tls(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must include a 'tls' block in its spec.\"\n}\n\nviolation[{\"msg\": msg}] {\n  input.review.kind.kind == \"ClientTrafficPolicy\"\n  input.review.object.apiVersion == \"gateway.envoyproxy.io/v1alpha1\"\n  not spec_has_target_refs(input.review.object.spec)\n  msg := \"ClientTrafficPolicy must include a 'targetRefs' block in its spec with the required 'group' and 'kind.'\"\n}\n\nspec_has_tls(spec) {\n  spec.tls != null\n}\n\nspec_has_target_refs(spec) {\n  targetRefs := spec.targetRefs\n  targetRefs[_].group == \"gateway.networking.k8s.io\"\n  targetRefs[_].kind == \"Gateway\"\n}\n"
    - target: admission.k8s.gatekeeper.sh
