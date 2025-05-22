apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: fluxdisablecrossnamespacesource
spec:
  crd:
    spec:
      names:
        kind: FluxDisableCrossNamespaceSource
  targets:
  - rego: "package fluxdisablecrossnamespacesource\n\nviolation[{\"msg\": msg}] {\n\tcheck_kind(input.review.kind.kind)\n\tinput.review.object.spec.sourceRef.namespace\n\tinput.review.object.spec.sourceRef.namespace
      != input.review.object.metadata.namespace\n\tmsg := sprintf(`'%v' in namespace
      '%v' cant use source in different namespace '%v'`, [input.review.kind.kind,
      input.review.object.metadata.namespace, input.review.object.spec.sourceRef.namespace])\n}\n\ncheck_kind(kind)
      {\n\tkind == \"HelmRelease\"\n}\n\ncheck_kind(kind) {\n\tkind == \"Kustomization\"\n}"
    target: admission.k8s.gatekeeper.sh