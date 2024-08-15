apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: azureidentityformat
spec:
  crd:
    spec:
      names:
        kind: AzureIdentityFormat
  targets:
  - rego: "package azureidentityformat\n\nviolation[{\"msg\": msg}] {\n\tinput.review.kind.kind
      == \"AzureIdentity\"\n\n\t# format of resourceId is checked only for user-assigned
      MSI\n\tinput.review.object.spec.type == 0\n\tresourceId := input.review.object.spec.resourceID\n\tresult
      := re_match(`(?i)/subscriptions/(.+?)/resourcegroups/(.+?)/providers/Microsoft.ManagedIdentity/(.+?)/(.+)`,
      resourceId)\n\tresult == false\n\tmsg := sprintf(`The identity resourceId '%v'
      is invalid.It must be of the following format: '/subscriptions/<subid>/resourcegroups/<resourcegroup>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<name>'`,
      [resourceId])\n}"
    target: admission.k8s.gatekeeper.sh