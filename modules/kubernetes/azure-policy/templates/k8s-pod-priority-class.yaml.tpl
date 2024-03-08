apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8spodpriorityclass
spec:
  crd:
    spec:
      names:
        kind: K8sPodPriorityClass
      validation:
        openAPIV3Schema:
          properties:
            permittedClassNames:
              items:
                type: string
              type: array
          type: object
  targets:
  - rego: "package k8spodpriorityclass\n\nviolation[{\"msg\": msg}] {\n\tinput.review.kind.kind
      == \"Pod\"\n\tpermittedClassNames := get_class_names(input.parameters, [\"\"])\n\tnot
      contains(permittedClassNames, input.review.object.spec.priorityClassName)\n\tmsg
      := sprintf(`The priority class name '%v' is not allowed`, [input.review.object.spec.priorityClassName])\n}\n\nget_class_names(parameters,
      _default) = msg {\n\tnot parameters.permittedClassNames\n\tmsg := _default\n}\n\nget_class_names(parameters,
      _default) = msg {\n\tmsg := parameters.permittedClassNames\n}\n\ncontains(arr,
      elem) {\n\tarr[_] = elem\n}"
    target: admission.k8s.gatekeeper.sh