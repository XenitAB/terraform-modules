apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: secretsstorecsiuniquevolume
spec:
  crd:
    spec:
      names:
        kind: SecretsStoreCSIUniqueVolume
  targets:
  - rego: "package secretsstorecsiuniquevolume\n\nviolation[{\"msg\": msg}] {\n\tvolumes
      := input.review.object.spec.volumes\n\tcount(volumes) > 0\n\tcsiVolumes = [x
      | x := volumes[_]; x.csi.driver = \"secrets-store.csi.k8s.io\"]\n\tuniqueNames
      := {x | x = csiVolumes[_].csi.volumeAttributes.secretProviderClass}\n\tcount(uniqueNames)
      != count(csiVolumes)\n\tmsg := sprintf(`'%v' cant have duplicate 'secretProviderClass'`,
      [input.review.kind.kind])\n}"
    target: admission.k8s.gatekeeper.sh