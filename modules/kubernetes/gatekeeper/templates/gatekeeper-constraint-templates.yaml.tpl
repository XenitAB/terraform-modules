apiVersion: templates.gatekeeper.sh/v1
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
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sallowedrepos
  annotations:
    metadata.gatekeeper.sh/title: "Allowed Repositories"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires container images to begin with a string from the specified list.
spec:
  crd:
    spec:
      names:
        kind: K8sAllowedRepos
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            repos:
              description: The list of prefixes a container image is allowed to have.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sallowedrepos

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          satisfied := [good | repo = input.parameters.repos[_] ; good = startswith(container.image, repo)]
          not any(satisfied)
          msg := sprintf("container <%v> has an invalid image repo <%v>, allowed repos are %v", [container.name, container.image, input.parameters.repos])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.initContainers[_]
          satisfied := [good | repo = input.parameters.repos[_] ; good = startswith(container.image, repo)]
          not any(satisfied)
          msg := sprintf("initContainer <%v> has an invalid image repo <%v>, allowed repos are %v", [container.name, container.image, input.parameters.repos])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.ephemeralContainers[_]
          satisfied := [good | repo = input.parameters.repos[_] ; good = startswith(container.image, repo)]
          not any(satisfied)
          msg := sprintf("ephemeralContainer <%v> has an invalid image repo <%v>, allowed repos are %v", [container.name, container.image, input.parameters.repos])
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sblockendpointeditdefaultrole
  annotations:
    metadata.gatekeeper.sh/title: "Block Endpoint Edit Default Role"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Many Kubernetes installations by default have a system:aggregate-to-edit
      ClusterRole which does not properly restrict access to editing Endpoints.
      This ConstraintTemplate forbids the system:aggregate-to-edit ClusterRole
      from granting permission to create/patch/update Endpoints.

      ClusterRole/system:aggregate-to-edit should not allow
      Endpoint edit permissions due to CVE-2021-25740, Endpoint & EndpointSlice
      permissions allow cross-Namespace forwarding,
      https://github.com/kubernetes/kubernetes/issues/103675
spec:
  crd:
    spec:
      names:
        kind: K8sBlockEndpointEditDefaultRole
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sblockendpointeditdefaultrole

        violation[{"msg": msg}] {
            input.review.object.metadata.name == "system:aggregate-to-edit"
            endpointRule(input.review.object.rules[_])
            msg := "ClusterRole system:aggregate-to-edit should not allow endpoint edit permissions. For k8s version < 1.22, the Cluster Role should be annotated with rbac.authorization.kubernetes.io/autoupdate=false to prevent autoreconciliation back to default permissions for this role."
        }

        endpointRule(rule) {
            "endpoints" == rule.resources[_]
            hasEditVerb(rule.verbs)
        }

        hasEditVerb(verbs) {
            "create" == verbs[_]
        }

        hasEditVerb(verbs) {
            "patch" == verbs[_]
        }

        hasEditVerb(verbs) {
            "update" == verbs[_]
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sblockloadbalancer
  annotations:
    metadata.gatekeeper.sh/title: "Block Services with type LoadBalancer"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Disallows all Services with type LoadBalancer.

      https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer
spec:
  crd:
    spec:
      names:
        kind: K8sBlockLoadBalancer
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sblockloadbalancer

        violation[{"msg": msg}] {
          input.review.kind.kind == "Service"
          input.review.object.spec.type == "LoadBalancer"
          msg := "User is not allowed to create service of type LoadBalancer"
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sblocknodeport
  annotations:
    metadata.gatekeeper.sh/title: "Block NodePort"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Disallows all Services with type NodePort.

      https://kubernetes.io/docs/concepts/services-networking/service/#nodeport
spec:
  crd:
    spec:
      names:
        kind: K8sBlockNodePort
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sblocknodeport

        violation[{"msg": msg}] {
          input.review.kind.kind == "Service"
          input.review.object.spec.type == "NodePort"
          msg := "User is not allowed to create service of type NodePort"
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sblockwildcardingress
  annotations:
    metadata.gatekeeper.sh/title: "Block wildcard ingress"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Users should not be able to create Ingresses with a blank or wildcard (*) hostname since that would enable them to intercept traffic for other services in the cluster, even if they don't have access to those services.
spec:
  crd:
    spec:
      names:
        kind: K8sBlockWildcardIngress
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package K8sBlockWildcardIngress

        contains_wildcard(hostname) = true {
          hostname == ""
        }

        contains_wildcard(hostname) = true {
          contains(hostname, "*")
        }

        violation[{"msg": msg}] {
          input.review.kind.kind == "Ingress"
          # object.get is required to detect omitted host fields
          hostname := object.get(input.review.object.spec.rules[_], "host", "")
          contains_wildcard(hostname)
          msg := sprintf("Hostname '%v' is not allowed since it counts as a wildcard, which can be used to intercept traffic from other applications.", [hostname])
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8scontainerlimits
  annotations:
    metadata.gatekeeper.sh/title: "Container Limits"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires containers to have memory and CPU limits set and constrains
      limits to be within the specified maximum values.

      https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
spec:
  crd:
    spec:
      names:
        kind: K8sContainerLimits
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            cpu:
              description: "The maximum allowed cpu limit on a Pod, exclusive."
              type: string
            memory:
              description: "The maximum allowed memory limit on a Pod, exclusive."
              type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8scontainerlimits

        import data.lib.exempt_container.is_exempt

        missing(obj, field) = true {
          not obj[field]
        }

        missing(obj, field) = true {
          obj[field] == ""
        }

        canonify_cpu(orig) = new {
          is_number(orig)
          new := orig * 1000
        }

        canonify_cpu(orig) = new {
          not is_number(orig)
          endswith(orig, "m")
          new := to_number(replace(orig, "m", ""))
        }

        canonify_cpu(orig) = new {
          not is_number(orig)
          not endswith(orig, "m")
          re_match("^[0-9]+(\\.[0-9]+)?$", orig)
          new := to_number(orig) * 1000
        }

        # 10 ** 21
        mem_multiple("E") = 1000000000000000000000 { true }

        # 10 ** 18
        mem_multiple("P") = 1000000000000000000 { true }

        # 10 ** 15
        mem_multiple("T") = 1000000000000000 { true }

        # 10 ** 12
        mem_multiple("G") = 1000000000000 { true }

        # 10 ** 9
        mem_multiple("M") = 1000000000 { true }

        # 10 ** 6
        mem_multiple("k") = 1000000 { true }

        # 10 ** 3
        mem_multiple("") = 1000 { true }

        # Kubernetes accepts millibyte precision when it probably shouldn't.
        # https://github.com/kubernetes/kubernetes/issues/28741
        # 10 ** 0
        mem_multiple("m") = 1 { true }

        # 1000 * 2 ** 10
        mem_multiple("Ki") = 1024000 { true }

        # 1000 * 2 ** 20
        mem_multiple("Mi") = 1048576000 { true }

        # 1000 * 2 ** 30
        mem_multiple("Gi") = 1073741824000 { true }

        # 1000 * 2 ** 40
        mem_multiple("Ti") = 1099511627776000 { true }

        # 1000 * 2 ** 50
        mem_multiple("Pi") = 1125899906842624000 { true }

        # 1000 * 2 ** 60
        mem_multiple("Ei") = 1152921504606846976000 { true }

        get_suffix(mem) = suffix {
          not is_string(mem)
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 0
          suffix := substring(mem, count(mem) - 1, -1)
          mem_multiple(suffix)
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 1
          suffix := substring(mem, count(mem) - 2, -1)
          mem_multiple(suffix)
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 1
          not mem_multiple(substring(mem, count(mem) - 1, -1))
          not mem_multiple(substring(mem, count(mem) - 2, -1))
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) == 1
          not mem_multiple(substring(mem, count(mem) - 1, -1))
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) == 0
          suffix := ""
        }

        canonify_mem(orig) = new {
          is_number(orig)
          new := orig * 1000
        }

        canonify_mem(orig) = new {
          not is_number(orig)
          suffix := get_suffix(orig)
          raw := replace(orig, suffix, "")
          re_match("^[0-9]+(\\.[0-9]+)?$", raw)
          new := to_number(raw) * mem_multiple(suffix)
        }

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "containers"}]
        }

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "initContainers"}]
        }

        # Ephemeral containers not checked as it is not possible to set field.

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          cpu_orig := container.resources.limits.cpu
          not canonify_cpu(cpu_orig)
          msg := sprintf("container <%v> cpu limit <%v> could not be parsed", [container.name, cpu_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          mem_orig := container.resources.limits.memory
          not canonify_mem(mem_orig)
          msg := sprintf("container <%v> memory limit <%v> could not be parsed", [container.name, mem_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          not container.resources
          msg := sprintf("container <%v> has no resource limits", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          not container.resources.limits
          msg := sprintf("container <%v> has no resource limits", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.limits, "cpu")
          msg := sprintf("container <%v> has no cpu limit", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.limits, "memory")
          msg := sprintf("container <%v> has no memory limit", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          cpu_orig := container.resources.limits.cpu
          cpu := canonify_cpu(cpu_orig)
          max_cpu_orig := input.parameters.cpu
          max_cpu := canonify_cpu(max_cpu_orig)
          cpu > max_cpu
          msg := sprintf("container <%v> cpu limit <%v> is higher than the maximum allowed of <%v>", [container.name, cpu_orig, max_cpu_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          mem_orig := container.resources.limits.memory
          mem := canonify_mem(mem_orig)
          max_mem_orig := input.parameters.memory
          max_mem := canonify_mem(max_mem_orig)
          mem > max_mem
          msg := sprintf("container <%v> memory limit <%v> is higher than the maximum allowed of <%v>", [container.name, mem_orig, max_mem_orig])
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8scontainerratios
  annotations:
    metadata.gatekeeper.sh/title: "Container Ratios"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Sets a maximum ratio for container resource limits to requests.

      https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
spec:
  crd:
    spec:
      names:
        kind: K8sContainerRatios
      validation:
        openAPIV3Schema:
          type: object
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            ratio:
              type: string
              description: >-
                The maximum allowed ratio of `resources.limits` to
                `resources.requests` on a container.
            cpuRatio:
              type: string
              description: >-
                The maximum allowed ratio of `resources.limits.cpu` to
                `resources.requests.cpu` on a container. If not specified,
                equal to `ratio`.
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8scontainerratios

        import data.lib.exempt_container.is_exempt

        missing(obj, field) = true {
          not obj[field]
        }

        missing(obj, field) = true {
          obj[field] == ""
        }

        canonify_cpu(orig) = new {
          is_number(orig)
          new := orig * 1000
        }

        canonify_cpu(orig) = new {
          not is_number(orig)
          endswith(orig, "m")
          new := to_number(replace(orig, "m", ""))
        }

        canonify_cpu(orig) = new {
          not is_number(orig)
          not endswith(orig, "m")
          re_match("^[0-9]+$", orig)
          new := to_number(orig) * 1000
        }

        canonify_cpu(orig) = new {
          not is_number(orig)
          not endswith(orig, "m")
          re_match("^[0-9]+[.][0-9]+$", orig)
          new := to_number(orig) * 1000
        }

        # 10 ** 21
        mem_multiple("E") = 1000000000000000000000 { true }

        # 10 ** 18
        mem_multiple("P") = 1000000000000000000 { true }

        # 10 ** 15
        mem_multiple("T") = 1000000000000000 { true }

        # 10 ** 12
        mem_multiple("G") = 1000000000000 { true }

        # 10 ** 9
        mem_multiple("M") = 1000000000 { true }

        # 10 ** 6
        mem_multiple("k") = 1000000 { true }

        # 10 ** 3
        mem_multiple("") = 1000 { true }

        # Kubernetes accepts millibyte precision when it probably shouldn't.
        # https://github.com/kubernetes/kubernetes/issues/28741
        # 10 ** 0
        mem_multiple("m") = 1 { true }

        # 1000 * 2 ** 10
        mem_multiple("Ki") = 1024000 { true }

        # 1000 * 2 ** 20
        mem_multiple("Mi") = 1048576000 { true }

        # 1000 * 2 ** 30
        mem_multiple("Gi") = 1073741824000 { true }

        # 1000 * 2 ** 40
        mem_multiple("Ti") = 1099511627776000 { true }

        # 1000 * 2 ** 50
        mem_multiple("Pi") = 1125899906842624000 { true }

        # 1000 * 2 ** 60
        mem_multiple("Ei") = 1152921504606846976000 { true }

        get_suffix(mem) = suffix {
          not is_string(mem)
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 0
          suffix := substring(mem, count(mem) - 1, -1)
          mem_multiple(suffix)
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 1
          suffix := substring(mem, count(mem) - 2, -1)
          mem_multiple(suffix)
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 1
          not mem_multiple(substring(mem, count(mem) - 1, -1))
          not mem_multiple(substring(mem, count(mem) - 2, -1))
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) == 1
          not mem_multiple(substring(mem, count(mem) - 1, -1))
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) == 0
          suffix := ""
        }

        canonify_mem(orig) = new {
          is_number(orig)
          new := orig * 1000
        }

        canonify_mem(orig) = new {
          not is_number(orig)
          suffix := get_suffix(orig)
          raw := replace(orig, suffix, "")
          re_match("^[0-9]+(\\.[0-9]+)?$", raw)
          new := to_number(raw) * mem_multiple(suffix)
        }

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "containers"}]
        }

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "initContainers"}]
        }

        # Ephemeral containers not checked as it is not possible to set field.

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          cpu_orig := container.resources.limits.cpu
          not canonify_cpu(cpu_orig)
          msg := sprintf("container <%v> cpu limit <%v> could not be parsed", [container.name, cpu_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          mem_orig := container.resources.limits.memory
          not canonify_mem(mem_orig)
          msg := sprintf("container <%v> memory limit <%v> could not be parsed", [container.name, mem_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          cpu_orig := container.resources.requests.cpu
          not canonify_cpu(cpu_orig)
          msg := sprintf("container <%v> cpu request <%v> could not be parsed", [container.name, cpu_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          mem_orig := container.resources.requests.memory
          not canonify_mem(mem_orig)
          msg := sprintf("container <%v> memory request <%v> could not be parsed", [container.name, mem_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          not container.resources
          msg := sprintf("container <%v> has no resource limits", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          not container.resources.limits
          msg := sprintf("container <%v> has no resource limits", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.limits, "cpu")
          msg := sprintf("container <%v> has no cpu limit", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.limits, "memory")
          msg := sprintf("container <%v> has no memory limit", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          not container.resources.requests
          msg := sprintf("container <%v> has no resource requests", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.requests, "cpu")
          msg := sprintf("container <%v> has no cpu request", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.requests, "memory")
          msg := sprintf("container <%v> has no memory request", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          cpu_limits_orig := container.resources.limits.cpu
          cpu_limits := canonify_cpu(cpu_limits_orig)
          cpu_requests_orig := container.resources.requests.cpu
          cpu_requests := canonify_cpu(cpu_requests_orig)
          cpu_ratio := object.get(input.parameters, "cpuRatio", input.parameters.ratio)
          to_number(cpu_limits) > to_number(cpu_ratio) * to_number(cpu_requests)
          msg := sprintf("container <%v> cpu limit <%v> is higher than the maximum allowed ratio of <%v>", [container.name, cpu_limits_orig, cpu_ratio])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          mem_limits_orig := container.resources.limits.memory
          mem_requests_orig := container.resources.requests.memory
          mem_limits := canonify_mem(mem_limits_orig)
          mem_requests := canonify_mem(mem_requests_orig)
          mem_ratio := input.parameters.ratio
          to_number(mem_limits) > to_number(mem_ratio) * to_number(mem_requests)
          msg := sprintf("container <%v> memory limit <%v> is higher than the maximum allowed ratio of <%v>", [container.name, mem_limits_orig, mem_ratio])
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8scontainerrequests
  annotations:
    metadata.gatekeeper.sh/title: "Container Requests"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires containers to have memory and CPU requests set and constrains
      requests to be within the specified maximum values.

      https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
spec:
  crd:
    spec:
      names:
        kind: K8sContainerRequests
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            cpu:
              description: "The maximum allowed cpu request on a Pod, exclusive."
              type: string
            memory:
              description: "The maximum allowed memory request on a Pod, exclusive."
              type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8scontainerrequests

        import data.lib.exempt_container.is_exempt

        missing(obj, field) = true {
          not obj[field]
        }

        missing(obj, field) = true {
          obj[field] == ""
        }

        canonify_cpu(orig) = new {
          is_number(orig)
          new := orig * 1000
        }

        canonify_cpu(orig) = new {
          not is_number(orig)
          endswith(orig, "m")
          new := to_number(replace(orig, "m", ""))
        }

        canonify_cpu(orig) = new {
          not is_number(orig)
          not endswith(orig, "m")
          re_match("^[0-9]+(\\.[0-9]+)?$", orig)
          new := to_number(orig) * 1000
        }

        # 10 ** 21
        mem_multiple("E") = 1000000000000000000000 { true }

        # 10 ** 18
        mem_multiple("P") = 1000000000000000000 { true }

        # 10 ** 15
        mem_multiple("T") = 1000000000000000 { true }

        # 10 ** 12
        mem_multiple("G") = 1000000000000 { true }

        # 10 ** 9
        mem_multiple("M") = 1000000000 { true }

        # 10 ** 6
        mem_multiple("k") = 1000000 { true }

        # 10 ** 3
        mem_multiple("") = 1000 { true }

        # Kubernetes accepts millibyte precision when it probably shouldn't.
        # https://github.com/kubernetes/kubernetes/issues/28741
        # 10 ** 0
        mem_multiple("m") = 1 { true }

        # 1000 * 2 ** 10
        mem_multiple("Ki") = 1024000 { true }

        # 1000 * 2 ** 20
        mem_multiple("Mi") = 1048576000 { true }

        # 1000 * 2 ** 30
        mem_multiple("Gi") = 1073741824000 { true }

        # 1000 * 2 ** 40
        mem_multiple("Ti") = 1099511627776000 { true }

        # 1000 * 2 ** 50
        mem_multiple("Pi") = 1125899906842624000 { true }

        # 1000 * 2 ** 60
        mem_multiple("Ei") = 1152921504606846976000 { true }

        get_suffix(mem) = suffix {
          not is_string(mem)
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 0
          suffix := substring(mem, count(mem) - 1, -1)
          mem_multiple(suffix)
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 1
          suffix := substring(mem, count(mem) - 2, -1)
          mem_multiple(suffix)
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) > 1
          not mem_multiple(substring(mem, count(mem) - 1, -1))
          not mem_multiple(substring(mem, count(mem) - 2, -1))
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) == 1
          not mem_multiple(substring(mem, count(mem) - 1, -1))
          suffix := ""
        }

        get_suffix(mem) = suffix {
          is_string(mem)
          count(mem) == 0
          suffix := ""
        }

        canonify_mem(orig) = new {
          is_number(orig)
          new := orig * 1000
        }

        canonify_mem(orig) = new {
          not is_number(orig)
          suffix := get_suffix(orig)
          raw := replace(orig, suffix, "")
          re_match("^[0-9]+(\\.[0-9]+)?$", raw)
          new := to_number(raw) * mem_multiple(suffix)
        }

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "containers"}]
        }

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "initContainers"}]
        }

        # Ephemeral containers not checked as it is not possible to set field.

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          cpu_orig := container.resources.requests.cpu
          not canonify_cpu(cpu_orig)
          msg := sprintf("container <%v> cpu request <%v> could not be parsed", [container.name, cpu_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          mem_orig := container.resources.requests.memory
          not canonify_mem(mem_orig)
          msg := sprintf("container <%v> memory request <%v> could not be parsed", [container.name, mem_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          not container.resources
          msg := sprintf("container <%v> has no resource requests", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          not container.resources.requests
          msg := sprintf("container <%v> has no resource requests", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.requests, "cpu")
          msg := sprintf("container <%v> has no cpu request", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          missing(container.resources.requests, "memory")
          msg := sprintf("container <%v> has no memory request", [container.name])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          cpu_orig := container.resources.requests.cpu
          cpu := canonify_cpu(cpu_orig)
          max_cpu_orig := input.parameters.cpu
          max_cpu := canonify_cpu(max_cpu_orig)
          cpu > max_cpu
          msg := sprintf("container <%v> cpu request <%v> is higher than the maximum allowed of <%v>", [container.name, cpu_orig, max_cpu_orig])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          mem_orig := container.resources.requests.memory
          mem := canonify_mem(mem_orig)
          max_mem_orig := input.parameters.memory
          max_mem := canonify_mem(max_mem_orig)
          mem > max_mem
          msg := sprintf("container <%v> memory request <%v> is higher than the maximum allowed of <%v>", [container.name, mem_orig, max_mem_orig])
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sdisallowanonymous
  annotations:
    metadata.gatekeeper.sh/title: "Disallow Anonymous Access"
    metadata.gatekeeper.sh/version: 1.0.0
    description: Disallows associating ClusterRole and Role resources to the system:anonymous user and system:unauthenticated group.
spec:
  crd:
    spec:
      names:
        kind: K8sDisallowAnonymous
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            allowedRoles:
              description: >-
                The list of ClusterRoles and Roles that may be associated
                with the `system:unauthenticated` group and `system:anonymous`
                user.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sdisallowanonymous

        violation[{"msg": msg}] {
          not is_allowed(input.review.object.roleRef, input.parameters.allowedRoles)
          review(input.review.object.subjects[_])
          msg := sprintf("Unauthenticated user reference is not allowed in %v %v ", [input.review.object.kind, input.review.object.metadata.name])
        }

        is_allowed(role, allowedRoles) {
          role.name == allowedRoles[_]
        }

        review(subject) = true {
          subject.name == "system:unauthenticated"
        }

        review(subject) = true {
          subject.name == "system:anonymous"
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sdisallowedtags
  annotations:
    metadata.gatekeeper.sh/title: "Disallow tags"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires container images to have an image tag different from the ones in
      the specified list.

      https://kubernetes.io/docs/concepts/containers/images/#image-names
spec:
  crd:
    spec:
      names:
        kind: K8sDisallowedTags
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.
                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            tags:
              type: array
              description: Disallowed container image tags.
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sdisallowedtags

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg}] {
            container := input_containers[_]
            not is_exempt(container)
            tags := [forbid | tag = input.parameters.tags[_] ; forbid = endswith(container.image, concat(":", ["", tag]))]
            any(tags)
            msg := sprintf("container <%v> uses a disallowed tag <%v>; disallowed tags are %v", [container.name, container.image, input.parameters.tags])
        }

        violation[{"msg": msg}] {
            container := input_containers[_]
            not is_exempt(container)
            tag := [contains(container.image, ":")]
            not all(tag)
            msg := sprintf("container <%v> didn't specify an image tag <%v>", [container.name, container.image])
        }

        input_containers[c] {
            c := input.review.object.spec.containers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }

---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sexternalips
  annotations:
    metadata.gatekeeper.sh/title: "External IPs"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Restricts Service externalIPs to an allowed list of IP addresses.

      https://kubernetes.io/docs/concepts/services-networking/service/#external-ips
spec:
  crd:
    spec:
      names:
        kind: K8sExternalIPs
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            allowedIPs:
              type: array
              description: "An allow-list of external IP addresses."
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sexternalips

        violation[{"msg": msg}] {
          input.review.kind.kind == "Service"
          input.review.kind.group == ""
          allowedIPs := {ip | ip := input.parameters.allowedIPs[_]}
          externalIPs := {ip | ip := input.review.object.spec.externalIPs[_]}
          forbiddenIPs := externalIPs - allowedIPs
          count(forbiddenIPs) > 0
          msg := sprintf("service has forbidden external IPs: %v", [forbiddenIPs])
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8shttpsonly
  annotations:
    metadata.gatekeeper.sh/title: "HTTPS only"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires Ingress resources to be HTTPS only.  Ingress resources must
      include the `kubernetes.io/ingress.allow-http` annotation, set to `false`.
      By default a valid TLS {} configuration is required, this can be made
      optional by setting the `tlsOptional` parameter to `true`.

      https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
spec:
  crd:
    spec:
      names:
        kind: K8sHttpsOnly
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Requires Ingress resources to be HTTPS only.  Ingress resources must
            include the `kubernetes.io/ingress.allow-http` annotation, set to
            `false`. By default a valid TLS {} configuration is required, this
            can be made optional by setting the `tlsOptional` parameter to
            `true`.
          properties:
            tlsOptional:
              type: boolean
              description: "When set to `true` the TLS {} is optional, defaults to false."
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8shttpsonly

        violation[{"msg": msg}] {
          input.review.object.kind == "Ingress"
          re_match("^(extensions|networking.k8s.io)/", input.review.object.apiVersion)
          ingress := input.review.object
          not https_complete(ingress)
          not tls_is_optional(ingress)
          msg := sprintf("Ingress should be https. tls configuration and allow-http=false annotation are required for %v", [ingress.metadata.name])
        }

        violation[{"msg": msg}] {
          input.review.object.kind == "Ingress"
          re_match("^(extensions|networking.k8s.io)/", input.review.object.apiVersion)
          ingress := input.review.object
          not annotation_complete(ingress)
          not tls_not_optional(ingress)
          msg := sprintf("Ingress should be https. The allow-http=false annotation is required for %v", [ingress.metadata.name])
        }

        https_complete(ingress) = true {
          ingress.spec["tls"]
          count(ingress.spec.tls) > 0
          ingress.metadata.annotations["kubernetes.io/ingress.allow-http"] == "false"
        }

        annotation_complete(ingress) = true {
          ingress.metadata.annotations["kubernetes.io/ingress.allow-http"] == "false"
        }

        tls_is_optional(ingress) = true {
          parameters := object.get(input, "parameters", {})
          tlsOptional := object.get(parameters, "tlsOptional", false)
          is_boolean(tlsOptional)
          true == tlsOptional
        }

        tls_not_optional(ingress) = true {
          parameters := object.get(input, "parameters", {})
          tlsOptional := object.get(parameters, "tlsOptional", false)
          true != tlsOptional
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8simagedigests
  annotations:
    metadata.gatekeeper.sh/title: "Image Digests"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires container images to contain a digest.

      https://kubernetes.io/docs/concepts/containers/images/
spec:
  crd:
    spec:
      names:
        kind: K8sImageDigests
      validation:
        openAPIV3Schema:
          type: object
          description: >-
            Requires container images to contain a digest.

            https://kubernetes.io/docs/concepts/containers/images/
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8simagedigests

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not is_exempt(container)
          satisfied := [re_match("@[a-z0-9]+([+._-][a-z0-9]+)*:[a-zA-Z0-9=_-]+", container.image)]
          not all(satisfied)
          msg := sprintf("container <%v> uses an image without a digest <%v>", [container.name, container.image])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.initContainers[_]
          not is_exempt(container)
          satisfied := [re_match("@[a-z0-9]+([+._-][a-z0-9]+)*:[a-zA-Z0-9=_-]+", container.image)]
          not all(satisfied)
          msg := sprintf("initContainer <%v> uses an image without a digest <%v>", [container.name, container.image])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.ephemeralContainers[_]
          not is_exempt(container)
          satisfied := [re_match("@[a-z0-9]+([+._-][a-z0-9]+)*:[a-zA-Z0-9=_-]+", container.image)]
          not all(satisfied)
          msg := sprintf("ephemeralContainer <%v> uses an image without a digest <%v>", [container.name, container.image])
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spoddisruptionbudget
  annotations:
    metadata.gatekeeper.sh/title: "Pod Disruption Budget"
    metadata.gatekeeper.sh/version: 1.0.2
    metadata.gatekeeper.sh/requiresSyncData: |
      "[
        [
          {
            "groups":["policy"],
            "versions": ["v1"],
            "kinds": ["PodDisruptionBudget"]
          }
        ]
      ]"
    description: >-
      Disallow the following scenarios when deploying PodDisruptionBudgets or resources that implement the replica subresource (e.g. Deployment, ReplicationController, ReplicaSet, StatefulSet):
      1. Deployment of PodDisruptionBudgets with .spec.maxUnavailable == 0
      2. Deployment of PodDisruptionBudgets with .spec.minAvailable == .spec.replicas of the resource with replica subresource
      This will prevent PodDisruptionBudgets from blocking voluntary disruptions such as node draining.

      https://kubernetes.io/docs/concepts/workloads/pods/disruptions/
spec:
  crd:
    spec:
      names:
        kind: K8sPodDisruptionBudget
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spoddisruptionbudget

        violation[{"msg": msg}] {
          input.review.kind.kind == "PodDisruptionBudget"
          pdb := input.review.object

          not valid_pdb_max_unavailable(pdb)
          msg := sprintf(
            "PodDisruptionBudget <%v> has maxUnavailable of 0, only positive integers are allowed for maxUnavailable",
            [pdb.metadata.name],
          )
        }

        violation[{"msg": msg}] {
          obj := input.review.object
          pdb := data.inventory.namespace[obj.metadata.namespace]["policy/v1"].PodDisruptionBudget[_]

          matchLabels := { [label, value] | some label; value := pdb.spec.selector.matchLabels[label] }
          labels := { [label, value] | some label; value := obj.spec.selector.matchLabels[label] }
          count(matchLabels - labels) == 0

          not valid_pdb_max_unavailable(pdb)
          msg := sprintf(
            "%v <%v> has been selected by PodDisruptionBudget <%v> but has maxUnavailable of 0, only positive integers are allowed for maxUnavailable",
            [obj.kind, obj.metadata.name, pdb.metadata.name],
          )
        }

        violation[{"msg": msg}] {
          obj := input.review.object
          pdb := data.inventory.namespace[obj.metadata.namespace]["policy/v1"].PodDisruptionBudget[_]
          
          matchLabels := { [label, value] | some label; value := pdb.spec.selector.matchLabels[label] }
          labels := { [label, value] | some label; value := obj.spec.selector.matchLabels[label] }
          count(matchLabels - labels) == 0

          not valid_pdb_min_available(obj, pdb)
          msg := sprintf(
            "%v <%v> has %v replica(s) but PodDisruptionBudget <%v> has minAvailable of %v, PodDisruptionBudget count should always be lower than replica(s), and not used when replica(s) is set to 1",
            [obj.kind, obj.metadata.name, obj.spec.replicas, pdb.metadata.name, pdb.spec.minAvailable],
          )
        }

        valid_pdb_min_available(obj, pdb) {
          # default to -1 if minAvailable is not set so valid_pdb_min_available is always true
          # for objects with >= 0 replicas. If minAvailable defaults to >= 0, objects with
          # replicas field might violate this constraint if they are equal to the default set here
          min_available := object.get(pdb.spec, "minAvailable", -1)
          obj.spec.replicas > min_available
        }

        valid_pdb_max_unavailable(pdb) {
          # default to 1 if maxUnavailable is not set so valid_pdb_max_unavailable always returns true.
          # If maxUnavailable defaults to 0, it violates this constraint because all pods needs to be
          # available and no pods can be evicted voluntarily
          max_unavailable := object.get(pdb.spec, "maxUnavailable", 1)
          max_unavailable > 0
        }
---
apiVersion: templates.gatekeeper.sh/v1
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
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspallowedusers
  annotations:
    metadata.gatekeeper.sh/title: "Allowed Users"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls the user and group IDs of the container and some volumes.
      Corresponds to the `runAsUser`, `runAsGroup`, `supplementalGroups`, and
      `fsGroup` fields in a PodSecurityPolicy. For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#users-and-groups
spec:
  crd:
    spec:
      names:
        kind: K8sPSPAllowedUsers
      validation:
        openAPIV3Schema:
          type: object
          description: >-
            Controls the user and group IDs of the container and some volumes.
            Corresponds to the `runAsUser`, `runAsGroup`, `supplementalGroups`, and
            `fsGroup` fields in a PodSecurityPolicy. For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#users-and-groups
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            runAsUser:
              type: object
              description: "Controls which user ID values are allowed in a Pod or container-level SecurityContext."
              properties:
                rule:
                  type: string
                  description: "A strategy for applying the runAsUser restriction."
                  enum:
                    - MustRunAs
                    - MustRunAsNonRoot
                    - RunAsAny
                ranges:
                  type: array
                  description: "A list of user ID ranges affected by the rule."
                  items:
                    type: object
                    description: "The range of user IDs affected by the rule."
                    properties:
                      min:
                        type: integer
                        description: "The minimum user ID in the range, inclusive."
                      max:
                        type: integer
                        description: "The maximum user ID in the range, inclusive."
            runAsGroup:
              type: object
              description: "Controls which group ID values are allowed in a Pod or container-level SecurityContext."
              properties:
                rule:
                  type: string
                  description: "A strategy for applying the runAsGroup restriction."
                  enum:
                    - MustRunAs
                    - MayRunAs
                    - RunAsAny
                ranges:
                  type: array
                  description: "A list of group ID ranges affected by the rule."
                  items:
                    type: object
                    description: "The range of group IDs affected by the rule."
                    properties:
                      min:
                        type: integer
                        description: "The minimum group ID in the range, inclusive."
                      max:
                        type: integer
                        description: "The maximum group ID in the range, inclusive."
            supplementalGroups:
              type: object
              description: "Controls the supplementalGroups values that are allowed in a Pod or container-level SecurityContext."
              properties:
                rule:
                  type: string
                  description: "A strategy for applying the supplementalGroups restriction."
                  enum:
                    - MustRunAs
                    - MayRunAs
                    - RunAsAny
                ranges:
                  type: array
                  description: "A list of group ID ranges affected by the rule."
                  items:
                    type: object
                    description: "The range of group IDs affected by the rule."
                    properties:
                      min:
                        type: integer
                        description: "The minimum group ID in the range, inclusive."
                      max:
                        type: integer
                        description: "The maximum group ID in the range, inclusive."
            fsGroup:
              type: object
              description: "Controls the fsGroup values that are allowed in a Pod or container-level SecurityContext."
              properties:
                rule:
                  type: string
                  description: "A strategy for applying the fsGroup restriction."
                  enum:
                    - MustRunAs
                    - MayRunAs
                    - RunAsAny
                ranges:
                  type: array
                  description: "A list of group ID ranges affected by the rule."
                  items:
                    type: object
                    description: "The range of group IDs affected by the rule."
                    properties:
                      min:
                        type: integer
                        description: "The minimum group ID in the range, inclusive."
                      max:
                        type: integer
                        description: "The maximum group ID in the range, inclusive."
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspallowedusers

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg}] {
          fields := ["runAsUser", "runAsGroup", "supplementalGroups", "fsGroup"]
          field := fields[_]
          container := input_containers[_]
          not is_exempt(container)
          msg := get_type_violation(field, container)
        }

        get_type_violation(field, container) = msg {
          field == "runAsUser"
          params := input.parameters[field]
          msg := get_user_violation(params, container)
        }

        get_type_violation(field, container) = msg {
          field != "runAsUser"
          params := input.parameters[field]
          msg := get_violation(field, params, container)
        }

        # RunAsUser (separate due to "MustRunAsNonRoot")
        get_user_violation(params, container) = msg {
          rule := params.rule
          provided_user := get_field_value("runAsUser", container, input.review)
          not accept_users(rule, provided_user)
          msg := sprintf("Container %v is attempting to run as disallowed user %v. Allowed runAsUser: %v", [container.name, provided_user, params])
        }

        get_user_violation(params, container) = msg {
          not get_field_value("runAsUser", container, input.review)
          params.rule = "MustRunAs"
          msg := sprintf("Container %v is attempting to run without a required securityContext/runAsUser", [container.name])
        }

        get_user_violation(params, container) = msg {
          params.rule = "MustRunAsNonRoot"
          not get_field_value("runAsUser", container, input.review)
          not get_field_value("runAsNonRoot", container, input.review)
          msg := sprintf("Container %v is attempting to run without a required securityContext/runAsNonRoot or securityContext/runAsUser != 0", [container.name])
        }

        accept_users("RunAsAny", provided_user) {true}

        accept_users("MustRunAsNonRoot", provided_user) = res {res := provided_user != 0}

        accept_users("MustRunAs", provided_user) = res  {
          ranges := input.parameters.runAsUser.ranges
          res := is_in_range(provided_user, ranges)
        }

        # Group Options
        get_violation(field, params, container) = msg {
          rule := params.rule
          provided_value := get_field_value(field, container, input.review)
          not is_array(provided_value)
          not accept_value(rule, provided_value, params.ranges)
          msg := sprintf("Container %v is attempting to run as disallowed group %v. Allowed %v: %v", [container.name, provided_value, field, params])
        }
        # SupplementalGroups is array value
        get_violation(field, params, container) = msg {
          rule := params.rule
          array_value := get_field_value(field, container, input.review)
          is_array(array_value)
          provided_value := array_value[_]
          not accept_value(rule, provided_value, params.ranges)
          msg := sprintf("Container %v is attempting to run with disallowed supplementalGroups %v. Allowed %v: %v", [container.name, array_value, field, params])
        }

        get_violation(field, params, container) = msg {
          not get_field_value(field, container, input.review)
          params.rule == "MustRunAs"
          msg := sprintf("Container %v is attempting to run without a required securityContext/%v. Allowed %v: %v", [container.name, field, field, params])
        }

        accept_value("RunAsAny", provided_value, ranges) {true}

        accept_value("MayRunAs", provided_value, ranges) = res { res := is_in_range(provided_value, ranges)}

        accept_value("MustRunAs", provided_value, ranges) = res { res := is_in_range(provided_value, ranges)}


        # If container level is provided, that takes precedence
        get_field_value(field, container, review) = out {
          container_value := get_seccontext_field(field, container)
          out := container_value
        }

        # If no container level exists, use pod level
        get_field_value(field, container, review) = out {
          not has_seccontext_field(field, container)
          review.kind.kind == "Pod"
          pod_value := get_seccontext_field(field, review.object.spec)
          out := pod_value
        }

        # Helper Functions
        is_in_range(val, ranges) = res {
          matching := {1 | val >= ranges[j].min; val <= ranges[j].max}
          res := count(matching) > 0
        }

        has_seccontext_field(field, obj) {
          get_seccontext_field(field, obj)
        }

        has_seccontext_field(field, obj) {
          get_seccontext_field(field, obj) == false
        }

        get_seccontext_field(field, obj) = out {
          out = obj.securityContext[field]
        }

        input_containers[c] {
          c := input.review.object.spec.containers[_]
        }
        input_containers[c] {
          c := input.review.object.spec.initContainers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspallowprivilegeescalationcontainer
  annotations:
    metadata.gatekeeper.sh/title: "Allow Privilege Escalation in Container"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls restricting escalation to root privileges. Corresponds to the
      `allowPrivilegeEscalation` field in a PodSecurityPolicy. For more
      information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#privilege-escalation
spec:
  crd:
    spec:
      names:
        kind: K8sPSPAllowPrivilegeEscalationContainer
      validation:
        openAPIV3Schema:
          type: object
          description: >-
            Controls restricting escalation to root privileges. Corresponds to the
            `allowPrivilegeEscalation` field in a PodSecurityPolicy. For more
            information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#privilege-escalation
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspallowprivilegeescalationcontainer

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            c := input_containers[_]
            not is_exempt(c)
            input_allow_privilege_escalation(c)
            msg := sprintf("Privilege escalation container is not allowed: %v", [c.name])
        }

        input_allow_privilege_escalation(c) {
            not has_field(c, "securityContext")
        }
        input_allow_privilege_escalation(c) {
            not c.securityContext.allowPrivilegeEscalation == false
        }
        input_containers[c] {
            c := input.review.object.spec.containers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
        }
        # has_field returns whether an object has a field
        has_field(object, field) = true {
            object[field]
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspapparmor
  annotations:
    metadata.gatekeeper.sh/title: "App Armor"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Configures an allow-list of AppArmor profiles for use by containers.
      This corresponds to specific annotations applied to a PodSecurityPolicy.
      For information on AppArmor, see
      https://kubernetes.io/docs/tutorials/clusters/apparmor/
spec:
  crd:
    spec:
      names:
        kind: K8sPSPAppArmor
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Configures an allow-list of AppArmor profiles for use by containers.
            This corresponds to specific annotations applied to a PodSecurityPolicy.
            For information on AppArmor, see
            https://kubernetes.io/docs/tutorials/clusters/apparmor/
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            allowedProfiles:
              description: "An array of AppArmor profiles. Examples: `runtime/default`, `unconfined`."
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspapparmor

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            metadata := input.review.object.metadata
            container := input_containers[_]
            not is_exempt(container)
            not input_apparmor_allowed(container, metadata)
            msg := sprintf("AppArmor profile is not allowed, pod: %v, container: %v. Allowed profiles: %v", [input.review.object.metadata.name, container.name, input.parameters.allowedProfiles])
        }

        input_apparmor_allowed(container, metadata) {
            get_annotation_for(container, metadata) == input.parameters.allowedProfiles[_]
        }

        input_containers[c] {
            c := input.review.object.spec.containers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
        }

        get_annotation_for(container, metadata) = out {
            out = metadata.annotations[sprintf("container.apparmor.security.beta.kubernetes.io/%v", [container.name])]
        }
        get_annotation_for(container, metadata) = out {
            not metadata.annotations[sprintf("container.apparmor.security.beta.kubernetes.io/%v", [container.name])]
            out = "runtime/default"
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspautomountserviceaccounttokenpod
  annotations:
    metadata.gatekeeper.sh/title: "Automount Service Account Token for Pod"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls the ability of any Pod to enable automountServiceAccountToken.
spec:
  crd:
    spec:
      names:
        kind: K8sPSPAutomountServiceAccountTokenPod
      validation:
        openAPIV3Schema:
          type: object
          description: >-
            Controls the ability of any Pod to enable automountServiceAccountToken.
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sautomountserviceaccounttoken

        violation[{"msg": msg}] {
            obj := input.review.object
            mountServiceAccountToken(obj.spec)
            msg := sprintf("Automounting service account token is disallowed, pod: %v", [obj.metadata.name])
        }

        mountServiceAccountToken(spec) {
            spec.automountServiceAccountToken == true
        }

        # if there is no automountServiceAccountToken spec, check on volumeMount in containers. Service Account token is mounted on /var/run/secrets/kubernetes.io/serviceaccount
        # https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/#serviceaccount-admission-controller
        mountServiceAccountToken(spec) {
            not has_key(spec, "automountServiceAccountToken")
            "/var/run/secrets/kubernetes.io/serviceaccount" == input_containers[_].volumeMounts[_].mountPath
        }

        input_containers[c] {
            c := input.review.object.spec.containers[_]
        }

        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
        }

        # Ephemeral containers not checked as it is not possible to set field.

        has_key(x, k) {
            _ = x[k]
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspcapabilities
  annotations:
    metadata.gatekeeper.sh/title: "Capabilities"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls Linux capabilities on containers. Corresponds to the
      `allowedCapabilities` and `requiredDropCapabilities` fields in a
      PodSecurityPolicy. For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#capabilities
spec:
  crd:
    spec:
      names:
        kind: K8sPSPCapabilities
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls Linux capabilities on containers. Corresponds to the
            `allowedCapabilities` and `requiredDropCapabilities` fields in a
            PodSecurityPolicy. For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#capabilities
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            allowedCapabilities:
              type: array
              description: "A list of Linux capabilities that can be added to a container."
              items:
                type: string
            requiredDropCapabilities:
              type: array
              description: "A list of Linux capabilities that are required to be dropped from a container."
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package capabilities

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not is_exempt(container)
          has_disallowed_capabilities(container)
          msg := sprintf("container <%v> has a disallowed capability. Allowed capabilities are %v", [container.name, get_default(input.parameters, "allowedCapabilities", "NONE")])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not is_exempt(container)
          missing_drop_capabilities(container)
          msg := sprintf("container <%v> is not dropping all required capabilities. Container must drop all of %v or \"ALL\"", [container.name, input.parameters.requiredDropCapabilities])
        }



        violation[{"msg": msg}] {
          container := input.review.object.spec.initContainers[_]
          not is_exempt(container)
          has_disallowed_capabilities(container)
          msg := sprintf("init container <%v> has a disallowed capability. Allowed capabilities are %v", [container.name, get_default(input.parameters, "allowedCapabilities", "NONE")])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.initContainers[_]
          not is_exempt(container)
          missing_drop_capabilities(container)
          msg := sprintf("init container <%v> is not dropping all required capabilities. Container must drop all of %v or \"ALL\"", [container.name, input.parameters.requiredDropCapabilities])
        }



        violation[{"msg": msg}] {
          container := input.review.object.spec.ephemeralContainers[_]
          not is_exempt(container)
          has_disallowed_capabilities(container)
          msg := sprintf("ephemeral container <%v> has a disallowed capability. Allowed capabilities are %v", [container.name, get_default(input.parameters, "allowedCapabilities", "NONE")])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.ephemeralContainers[_]
          not is_exempt(container)
          missing_drop_capabilities(container)
          msg := sprintf("ephemeral container <%v> is not dropping all required capabilities. Container must drop all of %v or \"ALL\"", [container.name, input.parameters.requiredDropCapabilities])
        }


        has_disallowed_capabilities(container) {
          allowed := {c | c := lower(input.parameters.allowedCapabilities[_])}
          not allowed["*"]
          capabilities := {c | c := lower(container.securityContext.capabilities.add[_])}

          count(capabilities - allowed) > 0
        }

        missing_drop_capabilities(container) {
          must_drop := {c | c := lower(input.parameters.requiredDropCapabilities[_])}
          all := {"all"}
          dropped := {c | c := lower(container.securityContext.capabilities.drop[_])}

          count(must_drop - dropped) > 0
          count(all - dropped) > 0
        }

        get_default(obj, param, _default) = out {
          out = obj[param]
        }

        get_default(obj, param, _default) = out {
          not obj[param]
          not obj[param] == false
          out = _default
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspflexvolumes
  annotations:
    metadata.gatekeeper.sh/title: "FlexVolumes"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls the allowlist of FlexVolume drivers. Corresponds to the
      `allowedFlexVolumes` field in PodSecurityPolicy. For more information,
      see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#flexvolume-drivers
spec:
  crd:
    spec:
      names:
        kind: K8sPSPFlexVolumes
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls the allowlist of FlexVolume drivers. Corresponds to the
            `allowedFlexVolumes` field in PodSecurityPolicy. For more information,
            see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#flexvolume-drivers
          properties:
            allowedFlexVolumes:
              type: array
              description: "An array of AllowedFlexVolume objects."
              items:
                type: object
                properties:
                  driver:
                    description: "The name of the FlexVolume driver."
                    type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspflexvolumes

        violation[{"msg": msg, "details": {}}] {
            volume := input_flexvolumes[_]
            not input_flexvolumes_allowed(volume)
            msg := sprintf("FlexVolume %v is not allowed, pod: %v. Allowed drivers: %v", [volume, input.review.object.metadata.name, input.parameters.allowedFlexVolumes])
        }

        input_flexvolumes_allowed(volume) {
            input.parameters.allowedFlexVolumes[_].driver == volume.flexVolume.driver
        }

        input_flexvolumes[v] {
            v := input.review.object.spec.volumes[_]
            has_field(v, "flexVolume")
        }

        # has_field returns whether an object has a field
        has_field(object, field) = true {
            object[field]
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspforbiddensysctls
  annotations:
    metadata.gatekeeper.sh/title: "Forbidden Sysctls"
    metadata.gatekeeper.sh/version: 1.1.0
    description: >-
      Controls the `sysctl` profile used by containers. Corresponds to the
      `allowedUnsafeSysctls` and `forbiddenSysctls` fields in a PodSecurityPolicy.
      When specified, any sysctl not in the `allowedSysctls` parameter is considered to be forbidden.
      The `forbiddenSysctls` parameter takes precedence over the `allowedSysctls` parameter.
      For more information, see https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/
spec:
  crd:
    spec:
      names:
        kind: K8sPSPForbiddenSysctls
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls the `sysctl` profile used by containers. Corresponds to the
            `allowedUnsafeSysctls` and `forbiddenSysctls` fields in a PodSecurityPolicy.
            When specified, any sysctl not in the `allowedSysctls` parameter is considered to be forbidden.
            The `forbiddenSysctls` parameter takes precedence over the `allowedSysctls` parameter.
            For more information, see https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/
          properties:
            allowedSysctls:
              type: array
              description: "An allow-list of sysctls. `*` allows all sysctls not listed in the `forbiddenSysctls` parameter."
              items:
                type: string
            forbiddenSysctls:
              type: array
              description: "A disallow-list of sysctls. `*` forbids all sysctls."
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspforbiddensysctls

        # Block if forbidden
        violation[{"msg": msg, "details": {}}] {
            sysctl := input.review.object.spec.securityContext.sysctls[_].name
            forbidden_sysctl(sysctl)
            msg := sprintf("The sysctl %v is not allowed, pod: %v. Forbidden sysctls: %v", [sysctl, input.review.object.metadata.name, input.parameters.forbiddenSysctls])
        }

        # Block if not explicitly allowed
        violation[{"msg": msg, "details": {}}] {
            sysctl := input.review.object.spec.securityContext.sysctls[_].name
            not allowed_sysctl(sysctl)
            msg := sprintf("The sysctl %v is not explictly allowed, pod: %v. Allowed sysctls: %v", [sysctl, input.review.object.metadata.name, input.parameters.allowedSysctls])
        }

        # * may be used to forbid all sysctls
        forbidden_sysctl(sysctl) {
            input.parameters.forbiddenSysctls[_] == "*"
        }

        forbidden_sysctl(sysctl) {
            input.parameters.forbiddenSysctls[_] == sysctl
        }

        forbidden_sysctl(sysctl) {
            forbidden := input.parameters.forbiddenSysctls[_]
            endswith(forbidden, "*")
            startswith(sysctl, trim_suffix(forbidden, "*"))
        }

        # * may be used to allow all sysctls
        allowed_sysctl(sysctl) {
            input.parameters.allowedSysctls[_] == "*"
        }

        allowed_sysctl(sysctl) {
            input.parameters.allowedSysctls[_] == sysctl
        }

        allowed_sysctl(sysctl) {
            allowed := input.parameters.allowedSysctls[_]
            endswith(allowed, "*")
            startswith(sysctl, trim_suffix(allowed, "*"))
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspfsgroup
  annotations:
    metadata.gatekeeper.sh/title: "FS Group"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls allocating an FSGroup that owns the Pod's volumes. Corresponds
      to the `fsGroup` field in a PodSecurityPolicy. For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
spec:
  crd:
    spec:
      names:
        kind: K8sPSPFSGroup
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls allocating an FSGroup that owns the Pod's volumes. Corresponds
            to the `fsGroup` field in a PodSecurityPolicy. For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
          properties:
            rule:
              description: "An FSGroup rule name."
              enum:
                - MayRunAs
                - MustRunAs
                - RunAsAny
              type: string
            ranges:
              type: array
              description: "GID ranges affected by the rule."
              items:
                type: object
                properties:
                  min:
                    description: "The minimum GID in the range, inclusive."
                    type: integer
                  max:
                    description: "The maximum GID in the range, inclusive."
                    type: integer
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspfsgroup

        violation[{"msg": msg, "details": {}}] {
            spec := input.review.object.spec
            not input_fsGroup_allowed(spec)
            msg := sprintf("The provided pod spec fsGroup is not allowed, pod: %v. Allowed fsGroup: %v", [input.review.object.metadata.name, input.parameters])
        }

        input_fsGroup_allowed(spec) {
            # RunAsAny - No range is required. Allows any fsGroup ID to be specified.
            input.parameters.rule == "RunAsAny"
        }
        input_fsGroup_allowed(spec) {
            # MustRunAs - Validates pod spec fsgroup against all ranges
            input.parameters.rule == "MustRunAs"
            fg := spec.securityContext.fsGroup
            count(input.parameters.ranges) > 0
            range := input.parameters.ranges[_]
            value_within_range(range, fg)
        }
        input_fsGroup_allowed(spec) {
            # MayRunAs - Validates pod spec fsgroup against all ranges or allow pod spec fsgroup to be left unset
            input.parameters.rule == "MayRunAs"
            not has_field(spec, "securityContext")
        }
        input_fsGroup_allowed(spec) {
            # MayRunAs - Validates pod spec fsgroup against all ranges or allow pod spec fsgroup to be left unset
            input.parameters.rule == "MayRunAs"
            not spec.securityContext.fsGroup
        }
        input_fsGroup_allowed(spec) {
            # MayRunAs - Validates pod spec fsgroup against all ranges or allow pod spec fsgroup to be left unset
            input.parameters.rule == "MayRunAs"
            fg := spec.securityContext.fsGroup
            count(input.parameters.ranges) > 0
            range := input.parameters.ranges[_]
            value_within_range(range, fg)
        }
        value_within_range(range, value) {
            range.min <= value
            range.max >= value
        }
        # has_field returns whether an object has a field
        has_field(object, field) = true {
            object[field]
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spsphostfilesystem
  annotations:
    metadata.gatekeeper.sh/title: "Host Filesystem"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls usage of the host filesystem. Corresponds to the
      `allowedHostPaths` field in a PodSecurityPolicy. For more information,
      see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
spec:
  crd:
    spec:
      names:
        kind: K8sPSPHostFilesystem
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls usage of the host filesystem. Corresponds to the
            `allowedHostPaths` field in a PodSecurityPolicy. For more information,
            see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
          properties:
            allowedHostPaths:
              type: array
              description: "An array of hostpath objects, representing paths and read/write configuration."
              items:
                type: object
                properties:
                  pathPrefix:
                    type: string
                    description: "The path prefix that the host volume must match."
                  readOnly:
                    type: boolean
                    description: "when set to true, any container volumeMounts matching the pathPrefix must include `readOnly: true`."
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spsphostfilesystem

        violation[{"msg": msg, "details": {}}] {
            volume := input_hostpath_volumes[_]
            allowedPaths := get_allowed_paths(input)
            input_hostpath_violation(allowedPaths, volume)
            msg := sprintf("HostPath volume %v is not allowed, pod: %v. Allowed path: %v", [volume, input.review.object.metadata.name, allowedPaths])
        }

        input_hostpath_violation(allowedPaths, volume) {
            # An empty list means all host paths are blocked
            allowedPaths == []
        }
        input_hostpath_violation(allowedPaths, volume) {
            not input_hostpath_allowed(allowedPaths, volume)
        }

        get_allowed_paths(arg) = out {
            not arg.parameters
            out = []
        }
        get_allowed_paths(arg) = out {
            not arg.parameters.allowedHostPaths
            out = []
        }
        get_allowed_paths(arg) = out {
            out = arg.parameters.allowedHostPaths
        }

        input_hostpath_allowed(allowedPaths, volume) {
            allowedHostPath := allowedPaths[_]
            path_matches(allowedHostPath.pathPrefix, volume.hostPath.path)
            not allowedHostPath.readOnly == true
        }

        input_hostpath_allowed(allowedPaths, volume) {
            allowedHostPath := allowedPaths[_]
            path_matches(allowedHostPath.pathPrefix, volume.hostPath.path)
            allowedHostPath.readOnly
            not writeable_input_volume_mounts(volume.name)
        }

        writeable_input_volume_mounts(volume_name) {
            container := input_containers[_]
            mount := container.volumeMounts[_]
            mount.name == volume_name
            not mount.readOnly
        }

        # This allows "/foo", "/foo/", "/foo/bar" etc., but
        # disallows "/fool", "/etc/foo" etc.
        path_matches(prefix, path) {
            a := path_array(prefix)
            b := path_array(path)
            prefix_matches(a, b)
        }
        path_array(p) = out {
            p != "/"
            out := split(trim(p, "/"), "/")
        }
        # This handles the special case for "/", since
        # split(trim("/", "/"), "/") == [""]
        path_array("/") = []

        prefix_matches(a, b) {
            count(a) <= count(b)
            not any_not_equal_upto(a, b, count(a))
        }

        any_not_equal_upto(a, b, n) {
            a[i] != b[i]
            i < n
        }

        input_hostpath_volumes[v] {
            v := input.review.object.spec.volumes[_]
            has_field(v, "hostPath")
        }

        # has_field returns whether an object has a field
        has_field(object, field) = true {
            object[field]
        }
        input_containers[c] {
            c := input.review.object.spec.containers[_]
        }

        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
        }

        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spsphostnamespace
  annotations:
    metadata.gatekeeper.sh/title: "Host Namespace"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Disallows sharing of host PID and IPC namespaces by pod containers.
      Corresponds to the `hostPID` and `hostIPC` fields in a PodSecurityPolicy.
      For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#host-namespaces
spec:
  crd:
    spec:
      names:
        kind: K8sPSPHostNamespace
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Disallows sharing of host PID and IPC namespaces by pod containers.
            Corresponds to the `hostPID` and `hostIPC` fields in a PodSecurityPolicy.
            For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#host-namespaces
          properties:
            exemptImages:
              description: |-
                Any container that uses an image that matches an entry in this list will be excluded from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.
                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name) in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
            exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
            img := container.image
            exemption := exempt_images[_]
            _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
            not endswith(exemption, "*")
            exemption == img
          }

          _matches_exemption(img, exemption) {
            endswith(exemption, "*")
            prefix := trim_suffix(exemption, "*")
            startswith(img, prefix)
          }
      rego: |
        package k8spsphostnamespace

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            c := input.parameters.exemptImages[_]
            not is_exempt(c)
            input_share_hostnamespace(input.review.object)
            msg := sprintf("Sharing the host namespace is not allowed: %v", [input.review.object.metadata.name])
        }

        input_share_hostnamespace(o) {
            o.spec.hostPID
        }
        input_share_hostnamespace(o) {
            o.spec.hostIPC
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spsphostnetworkingports
  annotations:
    metadata.gatekeeper.sh/title: "Host Networking Ports"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls usage of host network namespace by pod containers. Specific
      ports must be specified. Corresponds to the `hostNetwork` and
      `hostPorts` fields in a PodSecurityPolicy. For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#host-namespaces
spec:
  crd:
    spec:
      names:
        kind: K8sPSPHostNetworkingPorts
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls usage of host network namespace by pod containers. Specific
            ports must be specified. Corresponds to the `hostNetwork` and
            `hostPorts` fields in a PodSecurityPolicy. For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#host-namespaces
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            hostNetwork:
              description: "Determines if the policy allows the use of HostNetwork in the pod spec."
              type: boolean
            min:
              description: "The start of the allowed port range, inclusive."
              type: integer
            max:
              description: "The end of the allowed port range, inclusive."
              type: integer
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spsphostnetworkingports

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            input_share_hostnetwork(input.review.object)
            msg := sprintf("The specified hostNetwork and hostPort are not allowed, pod: %v. Allowed values: %v", [input.review.object.metadata.name, input.parameters])
        }

        input_share_hostnetwork(o) {
            not input.parameters.hostNetwork
            o.spec.hostNetwork
        }

        input_share_hostnetwork(o) {
            hostPort := input_containers[_].ports[_].hostPort
            hostPort < input.parameters.min
        }

        input_share_hostnetwork(o) {
            hostPort := input_containers[_].ports[_].hostPort
            hostPort > input.parameters.max
        }

        input_containers[c] {
            c := input.review.object.spec.containers[_]
            not is_exempt(c)
        }

        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
            not is_exempt(c)
        }

        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
            not is_exempt(c)
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspprivilegedcontainer
  annotations:
    metadata.gatekeeper.sh/title: "Privileged Container"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls the ability of any container to enable privileged mode.
      Corresponds to the `privileged` field in a PodSecurityPolicy. For more
      information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#privileged
spec:
  crd:
    spec:
      names:
        kind: K8sPSPPrivilegedContainer
      validation:
        openAPIV3Schema:
          type: object
          description: >-
            Controls the ability of any container to enable privileged mode.
            Corresponds to the `privileged` field in a PodSecurityPolicy. For more
            information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#privileged
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspprivileged

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            c := input_containers[_]
            not is_exempt(c)
            c.securityContext.privileged
            msg := sprintf("Privileged container is not allowed: %v, securityContext: %v", [c.name, c.securityContext])
        }

        input_containers[c] {
            c := input.review.object.spec.containers[_]
        }

        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
        }

        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspprocmount
  annotations:
    metadata.gatekeeper.sh/title: "Proc Mount"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls the allowed `procMount` types for the container. Corresponds to
      the `allowedProcMountTypes` field in a PodSecurityPolicy. For more
      information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#allowedprocmounttypes
spec:
  crd:
    spec:
      names:
        kind: K8sPSPProcMount
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls the allowed `procMount` types for the container. Corresponds to
            the `allowedProcMountTypes` field in a PodSecurityPolicy. For more
            information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#allowedprocmounttypes
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            procMount:
              type: string
              description: >-
                Defines the strategy for the security exposure of certain paths
                in `/proc` by the container runtime. Setting to `Default` uses
                the runtime defaults, where `Unmasked` bypasses the default
                behavior.
              enum:
                - Default
                - Unmasked
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspprocmount

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            c := input_containers[_]
            not is_exempt(c)
            allowedProcMount := get_allowed_proc_mount(input)
            not input_proc_mount_type_allowed(allowedProcMount, c)
            msg := sprintf("ProcMount type is not allowed, container: %v. Allowed procMount types: %v", [c.name, allowedProcMount])
        }

        input_proc_mount_type_allowed(allowedProcMount, c) {
            allowedProcMount == "default"
            lower(c.securityContext.procMount) == "default"
        }
        input_proc_mount_type_allowed(allowedProcMount, c) {
            allowedProcMount == "unmasked"
        }

        input_containers[c] {
            c := input.review.object.spec.containers[_]
            c.securityContext.procMount
        }
        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
            c.securityContext.procMount
        }
        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
            c.securityContext.procMount
        }

        get_allowed_proc_mount(arg) = out {
            not arg.parameters
            out = "default"
        }
        get_allowed_proc_mount(arg) = out {
            not arg.parameters.procMount
            out = "default"
        }
        get_allowed_proc_mount(arg) = out {
            not valid_proc_mount(arg.parameters.procMount)
            out = "default"
        }
        get_allowed_proc_mount(arg) = out {
            out = lower(arg.parameters.procMount)
        }

        valid_proc_mount(str) {
            lower(str) == "default"
        }
        valid_proc_mount(str) {
            lower(str) == "unmasked"
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  annotations:
    description: Requires the use of a read-only root file system by pod containers.
      Corresponds to the `readOnlyRootFilesystem` field in a PodSecurityPolicy. For
      more information, see https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
  name: k8spspreadonlyrootfilesystemxenit
spec:
  crd:
    spec:
      names:
        kind: K8sPSPReadOnlyRootFilesystemXenit
      validation:
        openAPIV3Schema:
          description: Requires the use of a read-only root file system by pod containers.
            Corresponds to the `readOnlyRootFilesystem` field in a PodSecurityPolicy.
            For more information, see https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
          properties:
            exemptImages:
              description: |-
                Any container that uses an image that matches an entry in this list will be excluded from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.
                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name) in order to avoid unexpectedly exempting images from an untrusted repository.
              items:
                type: string
              type: array
          type: object
  targets:
  - libs:
    - |
      package lib.exempt_container

      is_exempt(container) {
          exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
          img := container.image
          exemption := exempt_images[_]
          _matches_exemption(img, exemption)
      }

      _matches_exemption(img, exemption) {
          not endswith(exemption, "*")
          exemption == img
      }

      _matches_exemption(img, exemption) {
          endswith(exemption, "*")
          prefix := trim_suffix(exemption, "*")
          startswith(img, prefix)
      }
    rego: |-
      package k8spspreadonlyrootfilesystemxenit

      import data.lib.exempt_container.is_exempt

      violation[{"msg": msg, "details": {}}] {
          c := input_containers[_]
          not is_exempt(c)
          input_read_only_root_fs(c)
          msg := sprintf("only read-only root filesystem container is allowed: %v", [c.name])
      }

      input_read_only_root_fs(c) {
          not has_field(c, "securityContext")
      }
      input_read_only_root_fs(c) {
          not c.securityContext.readOnlyRootFilesystem == true
      }

      input_containers[c] {
          c := input.review.object.spec.containers[_]
      }
      input_containers[c] {
          c := input.review.object.spec.initContainers[_]
      }
      # To be able to use ephemeralContainers in a good way, we currently need to be able to write to disk.
      # Removal of this config is what differs from the upstream option, else it's a simple copy.
      # input_containers[c] {
      #    c := input.review.object.spec.ephemeralContainers[_]
      # }

      # has_field returns whether an object has a field
      has_field(object, field) = true {
          object[field]
      }
    target: admission.k8s.gatekeeper.sh
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspreadonlyrootfilesystem
  annotations:
    metadata.gatekeeper.sh/title: "Read Only Root Filesystem"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires the use of a read-only root file system by pod containers.
      Corresponds to the `readOnlyRootFilesystem` field in a
      PodSecurityPolicy. For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
spec:
  crd:
    spec:
      names:
        kind: K8sPSPReadOnlyRootFilesystem
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Requires the use of a read-only root file system by pod containers.
            Corresponds to the `readOnlyRootFilesystem` field in a
            PodSecurityPolicy. For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspreadonlyrootfilesystem

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            c := input_containers[_]
            not is_exempt(c)
            input_read_only_root_fs(c)
            msg := sprintf("only read-only root filesystem container is allowed: %v", [c.name])
        }

        input_read_only_root_fs(c) {
            not has_field(c, "securityContext")
        }
        input_read_only_root_fs(c) {
            not c.securityContext.readOnlyRootFilesystem == true
        }

        input_containers[c] {
            c := input.review.object.spec.containers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.initContainers[_]
        }
        input_containers[c] {
            c := input.review.object.spec.ephemeralContainers[_]
        }

        # has_field returns whether an object has a field
        has_field(object, field) = true {
            object[field]
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspseccomp
  annotations:
    metadata.gatekeeper.sh/title: "Seccomp"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Controls the seccomp profile used by containers. Corresponds to the
      `seccomp.security.alpha.kubernetes.io/allowedProfileNames` annotation on
      a PodSecurityPolicy. For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#seccomp
spec:
  crd:
    spec:
      names:
        kind: K8sPSPSeccomp
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Controls the seccomp profile used by containers. Corresponds to the
            `seccomp.security.alpha.kubernetes.io/allowedProfileNames` annotation on
            a PodSecurityPolicy. For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#seccomp
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            allowedProfiles:
              type: array
              description: >-
                An array of allowed profile values for seccomp on Pods/Containers.

                Can use the annotation naming scheme: `runtime/default`, `docker/default`, `unconfined` and/or
                `localhost/some-profile.json`. The item `localhost/*` will allow any localhost based profile.

                Can also use the securityContext naming scheme: `RuntimeDefault`, `Unconfined`
                and/or `Localhost`. For securityContext `Localhost`, use the parameter `allowedLocalhostProfiles`
                to list the allowed profile JSON files.

                The policy code will translate between the two schemes so it is not necessary to use both.

                Putting a `*` in this array allows all Profiles to be used.

                This field is required since with an empty list this policy will block all workloads.
              items:
                type: string
            allowedLocalhostFiles:
              type: array
              description: >-
                When using securityContext naming scheme for seccomp and including `Localhost` this array holds
                the allowed profile JSON files.

                Putting a `*` in this array will allows all JSON files to be used.

                This field is required to allow `Localhost` in securityContext as with an empty list it will block.
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspseccomp

        import data.lib.exempt_container.is_exempt

        container_annotation_key_prefix = "container.seccomp.security.alpha.kubernetes.io/"

        pod_annotation_key = "seccomp.security.alpha.kubernetes.io/pod"

        naming_translation = {
            # securityContext -> annotation
            "RuntimeDefault": ["runtime/default", "docker/default"],
            "Unconfined": ["unconfined"],
            "Localhost": ["localhost"],
            # annotation -> securityContext
            "runtime/default": ["RuntimeDefault"],
            "docker/default": ["RuntimeDefault"],
            "unconfined": ["Unconfined"],
            "localhost": ["Localhost"],
        }

        violation[{"msg": msg}] {
            not input_wildcard_allowed_profiles
            allowed_profiles := get_allowed_profiles
            container := input_containers[name]
            not is_exempt(container)
            result := get_profile(container)
            not allowed_profile(result.profile, result.file, allowed_profiles)
            msg := get_message(result.profile, result.file, name, result.location, allowed_profiles)
        }

        get_message(profile, file, name, location, allowed_profiles) = message {
            not profile == "Localhost"
            message := sprintf("Seccomp profile '%v' is not allowed for container '%v'. Found at: %v. Allowed profiles: %v", [profile, name, location, allowed_profiles])
        }

        get_message(profile, file, name, location, allowed_profiles) = message {
            profile == "Localhost"
            message := sprintf("Seccomp profile '%v' with file '%v' is not allowed for container '%v'. Found at: %v. Allowed profiles: %v", [profile, file, name, location, allowed_profiles])
        }

        input_wildcard_allowed_profiles {
            input.parameters.allowedProfiles[_] == "*"
        }

        input_wildcard_allowed_files {
            input.parameters.allowedLocalhostFiles[_] == "*"
        }

        input_wildcard_allowed_files {
            "localhost/*" == input.parameters.allowedProfiles[_]
        }

        # Simple allowed Profiles
        allowed_profile(profile, file, allowed) {
            not startswith(lower(profile), "localhost")
            profile == allowed[_]
        }

        # seccomp Localhost without wildcard
        allowed_profile(profile, file, allowed) {
            profile == "Localhost"
            not input_wildcard_allowed_files
            profile == allowed[_]
            allowed_files := {x | x := object.get(input.parameters, "allowedLocalhostFiles", [])[_]} | get_annotation_localhost_files
            file == allowed_files[_]
        }

        # seccomp Localhost with wildcard
        allowed_profile(profile, file, allowed) {
            profile == "Localhost"
            input_wildcard_allowed_files
            profile == allowed[_]
        }

        # annotation localhost with wildcard
        allowed_profile(profile, file, allowed) {
            "localhost/*" == allowed[_]
            startswith(profile, "localhost/")
        }

        # annotation localhost without wildcard
        allowed_profile(profile, file, allowed) {
            startswith(profile, "localhost/")
            profile == allowed[_]
        }

        # Localhost files from annotation scheme
        get_annotation_localhost_files[file] {
            profile := input.parameters.allowedProfiles[_]
            startswith(profile, "localhost/")
            file := replace(profile, "localhost/", "")
        }

        # The profiles explicitly in the list
        get_allowed_profiles[allowed] {
            allowed := input.parameters.allowedProfiles[_]
        }

        # The simply translated profiles
        get_allowed_profiles[allowed] {
            profile := input.parameters.allowedProfiles[_]
            not startswith(lower(profile), "localhost")
            allowed := naming_translation[profile][_]
        }

        # Seccomp Localhost to annotation translation
        get_allowed_profiles[allowed] {
            profile := input.parameters.allowedProfiles[_]
            profile == "Localhost"
            file := object.get(input.parameters, "allowedLocalhostFiles", [])[_]
            allowed := sprintf("%v/%v", [naming_translation[profile][_], file])
        }

        # Annotation localhost to Seccomp translation
        get_allowed_profiles[allowed] {
            profile := input.parameters.allowedProfiles[_]
            startswith(profile, "localhost")
            allowed := naming_translation.localhost[_]
        }

        # Container profile as defined in pod annotation
        get_profile(container) = {"profile": profile, "file": "", "location": location} {
            not has_securitycontext_container(container)
            not has_annotation(get_container_annotation_key(container.name))
            not has_securitycontext_pod
            profile := input.review.object.metadata.annotations[pod_annotation_key]
            location := sprintf("annotation %v", [pod_annotation_key])
        }

        # Container profile as defined in container annotation
        get_profile(container) = {"profile": profile, "file": "", "location": location} {
            not has_securitycontext_container(container)
            not has_securitycontext_pod
            container_annotation := get_container_annotation_key(container.name)
            has_annotation(container_annotation)
            profile := input.review.object.metadata.annotations[container_annotation]
            location := sprintf("annotation %v", [container_annotation])
        }

        # Container profile as defined in pods securityContext
        get_profile(container) = {"profile": profile, "file": file, "location": location} {
            not has_securitycontext_container(container)
            profile := input.review.object.spec.securityContext.seccompProfile.type
            file := object.get(input.review.object.spec.securityContext.seccompProfile, "localhostProfile", "")
            location := "pod securityContext"
        }

        # Container profile as defined in containers securityContext
        get_profile(container) = {"profile": profile, "file": file, "location": location} {
            has_securitycontext_container(container)
            profile := container.securityContext.seccompProfile.type
            file := object.get(container.securityContext.seccompProfile, "localhostProfile", "")
            location := "container securityContext"
        }

        # Container profile missing
        get_profile(container) = {"profile": "not configured", "file": "", "location": "no explicit profile found"} {
            not has_annotation(get_container_annotation_key(container.name))
            not has_annotation(pod_annotation_key)
            not has_securitycontext_pod
            not has_securitycontext_container(container)
        }

        has_annotation(annotation) {
            input.review.object.metadata.annotations[annotation]
        }

        has_securitycontext_pod {
            input.review.object.spec.securityContext.seccompProfile
        }

        has_securitycontext_container(container) {
            container.securityContext.seccompProfile
        }

        get_container_annotation_key(name) = annotation {
            annotation := concat("", [container_annotation_key_prefix, name])
        }

        input_containers[container.name] = container {
            container := input.review.object.spec.containers[_]
        }

        input_containers[container.name] = container {
            container := input.review.object.spec.initContainers[_]
        }

        input_containers[container.name] = container {
            container := input.review.object.spec.ephemeralContainers[_]
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspselinuxv2
  annotations:
    metadata.gatekeeper.sh/title: "SELinux V2"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Defines an allow-list of seLinuxOptions configurations for pod
      containers. Corresponds to a PodSecurityPolicy requiring SELinux configs.
      For more information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#selinux
spec:
  crd:
    spec:
      names:
        kind: K8sPSPSELinuxV2
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Defines an allow-list of seLinuxOptions configurations for pod
            containers. Corresponds to a PodSecurityPolicy requiring SELinux configs.
            For more information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#selinux
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            allowedSELinuxOptions:
              type: array
              description: "An allow-list of SELinux options configurations."
              items:
                type: object
                description: "An allowed configuration of SELinux options for a pod container."
                properties:
                  level:
                    type: string
                    description: "An SELinux level."
                  role:
                    type: string
                    description: "An SELinux role."
                  type:
                    type: string
                    description: "An SELinux type."
                  user:
                    type: string
                    description: "An SELinux user."
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spspselinux

        import data.lib.exempt_container.is_exempt

        # Disallow top level custom SELinux options
        violation[{"msg": msg, "details": {}}] {
            has_field(input.review.object.spec.securityContext, "seLinuxOptions")
            not input_seLinuxOptions_allowed(input.review.object.spec.securityContext.seLinuxOptions)
            msg := sprintf("SELinux options is not allowed, pod: %v. Allowed options: %v", [input.review.object.metadata.name, input.parameters.allowedSELinuxOptions])
        }
        # Disallow container level custom SELinux options
        violation[{"msg": msg, "details": {}}] {
            c := input_security_context[_]
            not is_exempt(c)
            has_field(c.securityContext, "seLinuxOptions")
            not input_seLinuxOptions_allowed(c.securityContext.seLinuxOptions)
            msg := sprintf("SELinux options is not allowed, pod: %v, container %v. Allowed options: %v", [input.review.object.metadata.name, c.name, input.parameters.allowedSELinuxOptions])
        }

        input_seLinuxOptions_allowed(options) {
            params := input.parameters.allowedSELinuxOptions[_]
            field_allowed("level", options, params)
            field_allowed("role", options, params)
            field_allowed("type", options, params)
            field_allowed("user", options, params)
        }

        field_allowed(field, options, params) {
            params[field] == options[field]
        }
        field_allowed(field, options, params) {
            not has_field(options, field)
        }

        input_security_context[c] {
            c := input.review.object.spec.containers[_]
            has_field(c.securityContext, "seLinuxOptions")
        }
        input_security_context[c] {
            c := input.review.object.spec.initContainers[_]
            has_field(c.securityContext, "seLinuxOptions")
        }
        input_security_context[c] {
            c := input.review.object.spec.ephemeralContainers[_]
            has_field(c.securityContext, "seLinuxOptions")
        }

        # has_field returns whether an object has a field
        has_field(object, field) = true {
            object[field]
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8spspvolumetypes
  annotations:
    metadata.gatekeeper.sh/title: "Volume Types"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Restricts mountable volume types to those specified by the user.
      Corresponds to the `volumes` field in a PodSecurityPolicy. For more
      information, see
      https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
spec:
  crd:
    spec:
      names:
        kind: K8sPSPVolumeTypes
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          description: >-
            Restricts mountable volume types to those specified by the user.
            Corresponds to the `volumes` field in a PodSecurityPolicy. For more
            information, see
            https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems
          properties:
            volumes:
              description: "`volumes` is an array of volume types. All volume types can be enabled using `*`."
              type: array
              items:
                type: string
            exemptImages:
              description: |-
                Any container that uses an image that matches an entry in this list will be excluded from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.
                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name) in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      libs:
      - |
        package lib.exempt_container

        is_exempt(container) {
            exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
            img := container.image
            exemption := exempt_images[_]
            _matches_exemption(img, exemption)
        }

        _matches_exemption(img, exemption) {
            not endswith(exemption, "*")
            exemption == img
        }

        _matches_exemption(img, exemption) {
            endswith(exemption, "*")
            prefix := trim_suffix(exemption, "*")
            startswith(img, prefix)
        }
      rego: |
        package k8spspvolumetypes

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg, "details": {}}] {
            c := input.parameters.exemptImages[_]
            not is_exempt(c)
            volume_fields := {x | input.review.object.spec.volumes[_][x]; x != "name"}
            field := volume_fields[_]
            not input_volume_type_allowed(field)
            msg := sprintf("The volume type %v is not allowed, pod: %v. Allowed volume types: %v", [field, input.review.object.metadata.name, input.parameters.volumes])
        }

        # * may be used to allow all volume types
        input_volume_type_allowed(field) {
            input.parameters.volumes[_] == "*"
        }

        input_volume_type_allowed(field) {
            field == input.parameters.volumes[_]
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sreplicalimits
  annotations:
    metadata.gatekeeper.sh/title: "Replica Limits"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires that objects with the field `spec.replicas` (Deployments,
      ReplicaSets, etc.) specify a number of replicas within defined ranges.
spec:
  crd:
    spec:
      names:
        kind: K8sReplicaLimits
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            ranges:
              type: array
              description: Allowed ranges for numbers of replicas.  Values are inclusive.
              items:
                type: object
                description: A range of allowed replicas.  Values are inclusive.
                properties:
                  min_replicas:
                    description: The minimum number of replicas allowed, inclusive.
                    type: integer
                  max_replicas:
                    description: The maximum number of replicas allowed, inclusive.
                    type: integer
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sreplicalimits

        deployment_name = input.review.object.metadata.name

        violation[{"msg": msg}] {
            spec := input.review.object.spec
            not input_replica_limit(spec)
            msg := sprintf("The provided number of replicas is not allowed for deployment: %v. Allowed ranges: %v", [deployment_name, input.parameters])
        }

        input_replica_limit(spec) {
            provided := input.review.object.spec.replicas
            count(input.parameters.ranges) > 0
            range := input.parameters.ranges[_]
            value_within_range(range, provided)
        }

        value_within_range(range, value) {
            range.min_replicas <= value
            range.max_replicas >= value
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredannotations
  annotations:
    metadata.gatekeeper.sh/title: "Required Annotations"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires resources to contain specified annotations, with values matching
      provided regular expressions.
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredAnnotations
      validation:
        openAPIV3Schema:
          type: object
          properties:
            message:
              type: string
            annotations:
              type: array
              description: >-
                A list of annotations and values the object must specify.
              items:
                type: object
                properties:
                  key:
                    type: string
                    description: >-
                      The required annotation.
                  allowedRegex:
                    type: string
                    description: >-
                      If specified, a regular expression the annotation's value
                      must match. The value must contain at least one match for
                      the regular expression.
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredannotations

        violation[{"msg": msg, "details": {"missing_annotations": missing}}] {
            provided := {annotation | input.review.object.metadata.annotations[annotation]}
            required := {annotation | annotation := input.parameters.annotations[_].key}
            missing := required - provided
            count(missing) > 0
            msg := sprintf("you must provide annotation(s): %v", [missing])
        }

        violation[{"msg": msg}] {
          value := input.review.object.metadata.annotations[key]
          expected := input.parameters.annotations[_]
          expected.key == key
          expected.allowedRegex != ""
          not re_match(expected.allowedRegex, value)
          msg := sprintf("Annotation <%v: %v> does not satisfy allowed regex: %v", [key, value, expected.allowedRegex])
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredlabels
  annotations:
    metadata.gatekeeper.sh/title: "Required Labels"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires resources to contain specified labels, with values matching
      provided regular expressions.
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredLabels
      validation:
        openAPIV3Schema:
          type: object
          properties:
            message:
              type: string
            labels:
              type: array
              description: >-
                A list of labels and values the object must specify.
              items:
                type: object
                properties:
                  key:
                    type: string
                    description: >-
                      The required label.
                  allowedRegex:
                    type: string
                    description: >-
                      If specified, a regular expression the annotation's value
                      must match. The value must contain at least one match for
                      the regular expression.
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredlabels

        get_message(parameters, _default) = msg {
          not parameters.message
          msg := _default
        }

        get_message(parameters, _default) = msg {
          msg := parameters.message
        }

        violation[{"msg": msg, "details": {"missing_labels": missing}}] {
          provided := {label | input.review.object.metadata.labels[label]}
          required := {label | label := input.parameters.labels[_].key}
          missing := required - provided
          count(missing) > 0
          def_msg := sprintf("you must provide labels: %v", [missing])
          msg := get_message(input.parameters, def_msg)
        }

        violation[{"msg": msg}] {
          value := input.review.object.metadata.labels[key]
          expected := input.parameters.labels[_]
          expected.key == key
          # do not match if allowedRegex is not defined, or is an empty string
          expected.allowedRegex != ""
          not re_match(expected.allowedRegex, value)
          def_msg := sprintf("Label <%v: %v> does not satisfy allowed regex: %v", [key, value, expected.allowedRegex])
          msg := get_message(input.parameters, def_msg)
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredprobes
  annotations:
    metadata.gatekeeper.sh/title: "Required Probes"
    metadata.gatekeeper.sh/version: 1.0.0
    description: Requires Pods to have readiness and/or liveness probes.
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredProbes
      validation:
        openAPIV3Schema:
          type: object
          properties:
            probes:
              description: "A list of probes that are required (ex: `readinessProbe`)"
              type: array
              items:
                type: string
            probeTypes:
              description: "The probe must define a field listed in `probeType` in order to satisfy the constraint (ex. `tcpSocket` satisfies `['tcpSocket', 'exec']`)"
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredprobes

        probe_type_set = probe_types {
            probe_types := {type | type := input.parameters.probeTypes[_]}
        }

        violation[{"msg": msg}] {
            container := input.review.object.spec.containers[_]
            probe := input.parameters.probes[_]
            probe_is_missing(container, probe)
            msg := get_violation_message(container, input.review, probe)
        }

        probe_is_missing(ctr, probe) = true {
            not ctr[probe]
        }

        probe_is_missing(ctr, probe) = true {
            probe_field_empty(ctr, probe)
        }

        probe_field_empty(ctr, probe) = true {
            probe_fields := {field | ctr[probe][field]}
            diff_fields := probe_type_set - probe_fields
            count(diff_fields) == count(probe_type_set)
        }

        get_violation_message(container, review, probe) = msg {
            msg := sprintf("Container <%v> in your <%v> <%v> has no <%v>", [container.name, review.kind.kind, review.object.metadata.name, probe])
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredresources
  annotations:
    metadata.gatekeeper.sh/title: "Required Resources"
    metadata.gatekeeper.sh/version: 1.0.0
    description: >-
      Requires containers to have defined resources set.

      https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredResources
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            exemptImages:
              description: >-
                Any container that uses an image that matches an entry in this list will be excluded
                from enforcement. Prefix-matching can be signified with `*`. For example: `my-image-*`.

                It is recommended that users use the fully-qualified Docker image name (e.g. start with a domain name)
                in order to avoid unexpectedly exempting images from an untrusted repository.
              type: array
              items:
                type: string
            limits:
              type: array
              description: "A list of limits that should be enforced (cpu, memory or both)."
              items:
                type: string
                enum:
                - cpu
                - memory
            requests:
              type: array
              description: "A list of requests that should be enforced (cpu, memory or both)."
              items:
                type: string
                enum:
                - cpu
                - memory
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredresources

        import data.lib.exempt_container.is_exempt

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "containers"}]
        }

        violation[{"msg": msg}] {
          general_violation[{"msg": msg, "field": "initContainers"}]
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          provided := {resource_type | container.resources.limits[resource_type]}
          required := {resource_type | resource_type := input.parameters.limits[_]}
          missing := required - provided
          count(missing) > 0
          msg := sprintf("container <%v> does not have <%v> limits defined", [container.name, missing])
        }

        general_violation[{"msg": msg, "field": field}] {
          container := input.review.object.spec[field][_]
          not is_exempt(container)
          provided := {resource_type | container.resources.requests[resource_type]}
          required := {resource_type | resource_type := input.parameters.requests[_]}
          missing := required - provided
          count(missing) > 0
          msg := sprintf("container <%v> does not have <%v> requests defined", [container.name, missing])
        }
      libs:
        - |
          package lib.exempt_container

          is_exempt(container) {
              exempt_images := object.get(object.get(input, "parameters", {}), "exemptImages", [])
              img := container.image
              exemption := exempt_images[_]
              _matches_exemption(img, exemption)
          }

          _matches_exemption(img, exemption) {
              not endswith(exemption, "*")
              exemption == img
          }

          _matches_exemption(img, exemption) {
              endswith(exemption, "*")
              prefix := trim_suffix(exemption, "*")
              startswith(img, prefix)
          }
---
apiVersion: templates.gatekeeper.sh/v1
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
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sstorageclass
  annotations:
    metadata.gatekeeper.sh/title: "Storage Class"
    metadata.gatekeeper.sh/version: 1.0.1
    metadata.gatekeeper.sh/requiresSyncData: |
      "[
        [
          {
            "groups":["storage.k8s.io"],
            "versions": ["v1"],
            "kinds": ["StorageClass"]
          }
        ]
      ]"
    description: >-
      Requires storage classes to be specified when used. Only Gatekeeper 3.9+ is supported.
spec:
  crd:
    spec:
      names:
        kind: K8sStorageClass
      validation:
        openAPIV3Schema:
          type: object
          description: >-
            Requires storage classes to be specified when used.
          properties:
            includeStorageClassesInMessage:
              type: boolean
              default: true
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sstorageclass

        is_pvc(obj) {
          obj.apiVersion == "v1"
          obj.kind == "PersistentVolumeClaim"
        }

        is_statefulset(obj) {
          obj.apiVersion == "apps/v1"
          obj.kind == "StatefulSet"
        }

        violation[{"msg": msg}] {
          not data.inventory.cluster["storage.k8s.io/v1"]["StorageClass"]
          msg := sprintf("StorageClasses not synced. Gatekeeper may be misconfigured. Please have a cluster-admin consult the documentation.", [])
        }

        storageclass_found(name) {
          data.inventory.cluster["storage.k8s.io/v1"]["StorageClass"][name]
        }

        violation[{"msg": pvc_storageclass_badname_msg}] {
          is_pvc(input.review.object)
          not storageclass_found(input.review.object.spec.storageClassName)
        }
        pvc_storageclass_badname_msg := sprintf("pvc did not specify a valid storage class name <%v>. Must be one of [%v]", args) {
          input.parameters.includeStorageClassesInMessage
          args := [
            input.review.object.spec.storageClassName,
            concat(", ", [n | data.inventory.cluster["storage.k8s.io/v1"]["StorageClass"][n]])
          ]
        } else := sprintf(
          "pvc did not specify a valid storage class name <%v>.",
          [input.review.object.spec.storageClassName]
        )

        violation[{"msg": pvc_storageclass_noname_msg}] {
          is_pvc(input.review.object)
          not input.review.object.spec.storageClassName
        }
        pvc_storageclass_noname_msg := sprintf("pvc did not specify a storage class name. Must be one of [%v]", args) {
          input.parameters.includeStorageClassesInMessage
          args := [
            concat(", ", [n | data.inventory.cluster["storage.k8s.io/v1"]["StorageClass"][n]])
          ]
        } else := sprintf(
          "pvc did not specify a storage class name.",
          []
        )

        violation[{"msg": statefulset_vct_badname_msg(vct)}] {
          is_statefulset(input.review.object)
          vct := input.review.object.spec.volumeClaimTemplates[_]
          not storageclass_found(vct.spec.storageClassName)
        }
        statefulset_vct_badname_msg(vct) := msg {
          input.parameters.includeStorageClassesInMessage
          msg := sprintf(
              "statefulset did not specify a valid storage class name <%v>. Must be one of [%v]", [
              vct.spec.storageClassName,
              concat(", ", [n | data.inventory.cluster["storage.k8s.io/v1"]["StorageClass"][n]])
          ])
        }
        statefulset_vct_badname_msg(vct) := msg {
          not input.parameters.includeStorageClassesInMessage
          msg := sprintf(
            "statefulset did not specify a valid storage class name <%v>.", [
              vct.spec.storageClassName
          ])
        }

        violation[{"msg": statefulset_vct_noname_msg}] {
          is_statefulset(input.review.object)
          vct := input.review.object.spec.volumeClaimTemplates[_]
          not vct.spec.storageClassName
        }
        statefulset_vct_noname_msg := sprintf("statefulset did not specify a storage class name. Must be one of [%v]", args) {
          input.parameters.includeStorageClassesInMessage
          args := [
            concat(", ", [n | data.inventory.cluster["storage.k8s.io/v1"]["StorageClass"][n]])
          ]
        } else := sprintf(
          "statefulset did not specify a storage class name.",
          []
        )

        #FIXME pod generic ephemeral might be good to validate some day too.
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8suniqueingresshost
  annotations:
    metadata.gatekeeper.sh/title: "Unique Ingress Host"
    metadata.gatekeeper.sh/version: 1.0.2
    metadata.gatekeeper.sh/requiresSyncData: |
      "[
        [
          {
            "groups": ["extensions"],
            "versions": ["v1beta1"],
            "kinds": ["Ingress"]
          },
          {
            "groups": ["networking.k8s.io"],
            "versions": ["v1beta1", "v1"],
            "kinds": ["Ingress"]
          }
        ]
      ]"
    description: >-
      Requires all Ingress rule hosts to be unique.

      Does not handle hostname wildcards:
      https://kubernetes.io/docs/concepts/services-networking/ingress/
spec:
  crd:
    spec:
      names:
        kind: K8sUniqueIngressHost
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8suniqueingresshost

        identical(obj, review) {
          obj.metadata.namespace == review.object.metadata.namespace
          obj.metadata.name == review.object.metadata.name
        }

        violation[{"msg": msg}] {
          input.review.kind.kind == "Ingress"
          re_match("^(extensions|networking.k8s.io)$", input.review.kind.group)
          host := input.review.object.spec.rules[_].host
          other := data.inventory.namespace[_][otherapiversion]["Ingress"][name]
          re_match("^(extensions|networking.k8s.io)/.+$", otherapiversion)
          other.spec.rules[_].host == host
          not identical(other, input.review)
          msg := sprintf("ingress host conflicts with an existing ingress <%v>", [host])
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8suniqueserviceselector
  annotations:
    metadata.gatekeeper.sh/title: "Unique Service Selector"
    metadata.gatekeeper.sh/version: 1.0.1
    metadata.gatekeeper.sh/requiresSyncData: |
      "[
        [
          {
            "groups":[""],
            "versions": ["v1"],
            "kinds": ["Service"]
          }
        ]
      ]"
    description: >-
      Requires Services to have unique selectors within a namespace.
      Selectors are considered the same if they have identical keys and values.
      Selectors may share a key/value pair so long as there is at least one
      distinct key/value pair between them.

      https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service
spec:
  crd:
    spec:
      names:
        kind: K8sUniqueServiceSelector
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8suniqueserviceselector

        make_apiversion(kind) = apiVersion {
          g := kind.group
          v := kind.version
          g != ""
          apiVersion = sprintf("%v/%v", [g, v])
        }

        make_apiversion(kind) = apiVersion {
          kind.group == ""
          apiVersion = kind.version
        }

        identical(obj, review) {
          obj.metadata.namespace == review.namespace
          obj.metadata.name == review.name
          obj.kind == review.kind.kind
          obj.apiVersion == make_apiversion(review.kind)
        }

        flatten_selector(obj) = flattened {
          selectors := [s | s = concat(":", [key, val]); val = obj.spec.selector[key]]
          flattened := concat(",", sort(selectors))
        }

        violation[{"msg": msg}] {
          input.review.kind.kind == "Service"
          input.review.kind.version == "v1"
          input.review.kind.group == ""
          input_selector := flatten_selector(input.review.object)
          other := data.inventory.namespace[namespace][_]["Service"][name]
          not identical(other, input.review)
          other_selector := flatten_selector(other)
          input_selector == other_selector
          msg := sprintf("same selector as service <%v> in namespace <%v>", [name, namespace])
        }
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: noupdateserviceaccount
  annotations:
    metadata.gatekeeper.sh/title: "Block updating Service Account"
    metadata.gatekeeper.sh/version: 1.0.0
    description: "Blocks updating the service account on resources that abstract over Pods. This policy is ignored in audit mode."
spec:
  crd:
    spec:
      names:
        kind: NoUpdateServiceAccount
      validation:
        openAPIV3Schema:
          type: object
          properties:
            allowedGroups:
              description: Groups that should be allowed to bypass the policy.
              type: array
              items:
                type: string
            allowedUsers:
              description: Users that should be allowed to bypass the policy.
              type: array
              items:
                type: string
  targets:
  - target: admission.k8s.gatekeeper.sh
    rego: |
      package noupdateserviceaccount

      privileged(userInfo, allowedUsers, allowedGroups) {
        # Allow if the user is in allowedUsers.
        # Use object.get so omitted parameters can't cause policy bypass by
        # evaluating to undefined.
        username := object.get(userInfo, "username", "")
        allowedUsers[_] == username
      } {
        # Allow if the user's groups intersect allowedGroups.
        # Use object.get so omitted parameters can't cause policy bypass by
        # evaluating to undefined.
        userGroups := object.get(userInfo, "groups", [])
        groups := {g | g := userGroups[_]}
        allowed := {g | g := allowedGroups[_]}
        intersection := groups & allowed
        count(intersection) > 0
      }

      get_service_account(obj) = spec {
        obj.kind == "Pod"
        spec := obj.spec.serviceAccountName
      } {
        obj.kind == "ReplicationController"
        spec := obj.spec.template.spec.serviceAccountName
      } {
        obj.kind == "ReplicaSet"
        spec := obj.spec.template.spec.serviceAccountName
      } {
        obj.kind == "Deployment"
        spec := obj.spec.template.spec.serviceAccountName
      } {
        obj.kind == "StatefulSet"
        spec := obj.spec.template.spec.serviceAccountName
      } {
        obj.kind == "DaemonSet"
        spec := obj.spec.template.spec.serviceAccountName
      } {
        obj.kind == "Job"
        spec := obj.spec.template.spec.serviceAccountName
      } {
        obj.kind == "CronJob"
        spec := obj.spec.jobTemplate.spec.template.spec.serviceAccountName
      }

      violation[{"msg": msg}] {
        # This policy only applies to updates of existing resources.
        input.review.operation == "UPDATE"

        # Use object.get so omitted parameters can't cause policy bypass by
        # evaluating to undefined.
        params := object.get(input, "parameters", {})
        allowedUsers := object.get(params, "allowedUsers", [])
        allowedGroups := object.get(params, "allowedGroups", [])

        # Extract the service account.
        oldKSA := get_service_account(input.review.oldObject)
        newKSA := get_service_account(input.review.object)

        # Deny unprivileged users and groups from changing serviceAccountName.
        not privileged(input.review.userInfo, allowedUsers, allowedGroups)
        oldKSA != newKSA
        msg := "user does not have permission to modify serviceAccountName"
      } {
        # Defensively require object to have a serviceAccountName.
        input.review.operation == "UPDATE"
        not get_service_account(input.review.object)
        msg := "missing serviceAccountName field in object under review"
      } {
        # Defensively require oldObject to have a serviceAccountName.
        input.review.operation == "UPDATE"
        not get_service_account(input.review.oldObject)
        msg := "missing serviceAccountName field in oldObject under review"
      }
---
apiVersion: templates.gatekeeper.sh/v1
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
