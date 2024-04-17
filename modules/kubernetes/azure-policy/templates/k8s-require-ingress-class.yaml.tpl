apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8srequireingressclass
spec:
  crd:
    spec:
      names:
        kind: K8sRequireIngressClass
      validation:
        openAPIV3Schema:
          properties:
            permittedClassNames:
              items:
                type: string
              type: array
          type: object
  targets:
  - rego: "package k8srequireingressclass\n\nviolation[{\"msg\": msg}] {\n\tinput.review.kind.kind
      == \"Ingress\"\n\tnot input.review.object.spec.ingressClassName\n\tmsg := \"Ingress
      class name has to be set\"\n}\n\nviolation[{\"msg\": msg}] {\n\tinput.review.kind.kind
      == \"Ingress\"\n\tinput.review.object.spec.ingressClassName == \"\"\n\tmsg :=
      \"Ingress class name cannot be an emtpy string\"\n}"
    target: admission.k8s.gatekeeper.sh