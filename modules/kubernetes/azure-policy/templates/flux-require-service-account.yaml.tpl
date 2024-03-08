apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: fluxrequireserviceaccount
spec:
  crd:
    spec:
      names:
        kind: FluxRequireServiceAccount
  targets:
  - rego: "package fluxrequireserviceaccount\n\nviolation[{\"msg\": msg}] {\n\tcheck_kind(input.review.kind.kind)\n\tcheck_service_account(input.review.object.spec)\n\tmsg
      := sprintf(`'%v' has to specify a serviceAccountName`, [input.review.kind.kind])\n}\n\ncheck_kind(kind)
      {\n\tkind == \"HelmRelease\"\n}\n\ncheck_kind(kind) {\n\tkind == \"Kustomization\"\n}\n\ncheck_service_account(spec)
      {\n\tspec.serviceAccountName == \"\"\n}\n\ncheck_service_account(spec) {\n\tnot
      spec.serviceAccountName\n}"
    target: admission.k8s.gatekeeper.sh