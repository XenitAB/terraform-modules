apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-probes
  annotations:
    policies.kyverno.io/title: Require Probes
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Containers should have readiness probes configured to ensure proper application health.
      This policy is set to warn mode to match the Gatekeeper dryrun equivalent.
spec:
  validationFailureAction: Audit
  background: true
  rules:
  - name: check-readiness-probe
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          - "kube-system"
          - "reloader"
          - "falco"
          - "flux-system"
          - "spegel"
          - "trivy"
          - "gatekeeper-system"
          - "kyverno"
          - "vpa"
          - "external-dns"
          - "cert-manager"
    validate:
      message: "Containers should have readiness probes configured"
      pattern:
        spec:
          containers:
          - name: "*"
            readinessProbe:
              tcpSocket: "*"
              httpGet: "*"
              exec: "*"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: deny-invalid-pdb
  annotations:
    policies.kyverno.io/title: Deny overly restrictive PodDisruptionBudget
    policies.kyverno.io/category: Reliability
    policies.kyverno.io/severity: high
    policies.kyverno.io/description: >
      Denies creation of a PodDisruptionBudget where .spec.minAvailable
      is greater than or equal to the number of replicas defined in the matching
      Deployment or HPA. Prevents upgrade issues where nodes cannot be drained.
spec:
  validationFailureAction: enforce
  background: true
  rules:
    # Rule when an HPA exists: compare minAvailable to HPA minReplicas
    - name: deny-pdb-minavailable-too-high-with-hpa
      match:
        any:
        - resources:
            kinds:
            - PodDisruptionBudget
            operations:
            - CREATE
            - UPDATE
      exclude:
        any:
        - resources:
            namespaces:
            - "kube-system"
      context:
        - name: deployment
          apiCall:
            urlPath: "/apis/apps/v1/namespaces/{{ request.namespace }}/deployments"
            jmesPath: "items[?spec.selector.matchLabels.app==request.object.spec.selector.matchLabels.app || spec.selector.matchLabels.\"app.kubernetes.io/name\"==request.object.spec.selector.matchLabels.\"app.kubernetes.io/name\"]"
        - name: hpa
          apiCall:
            urlPath: "/apis/autoscaling/v2/namespaces/{{ request.namespace }}/horizontalpodautoscalers"
            jmesPath: "items[?spec.scaleTargetRef.kind=='Deployment' && spec.scaleTargetRef.name==deployment[0].metadata.name]"
      preconditions:
        all:
          - key: "{{ request.object.spec.selector.matchLabels | length(@) }}"
            operator: GreaterThan
            value: 0
          - key: "{{ deployment | length(@) }}"
            operator: GreaterThan
            value: 0
          - key: "{{ hpa | length(@) }}"
            operator: GreaterThan
            value: 0
      validate:
        message: "PodDisruptionBudget minAvailable must be less than HPA minReplicas."
        deny:
          conditions:
            any:
              - key: "{{ request.object.spec.minAvailable }}"
                operator: GreaterThanOrEquals
                value: "{{ hpa[0].spec.minReplicas }}"
    # Rule when no HPA exists: compare minAvailable to Deployment replicas
    - name: deny-pdb-minavailable-too-high-no-hpa
      match:
        any:
        - resources:
            kinds:
            - PodDisruptionBudget
            operations:
            - CREATE
            - UPDATE
      exclude:
        any:
        - resources:
            namespaces:
            - "kube-system"
      context:
        - name: deployment
          apiCall:
            urlPath: "/apis/apps/v1/namespaces/{{ request.namespace }}/deployments"
            jmesPath: "items[?spec.selector.matchLabels.app==request.object.spec.selector.matchLabels.app || spec.selector.matchLabels.\"app.kubernetes.io/name\"==request.object.spec.selector.matchLabels.\"app.kubernetes.io/name\"]"
        - name: hpa
          apiCall:
            urlPath: "/apis/autoscaling/v2/namespaces/{{ request.namespace }}/horizontalpodautoscalers"
            jmesPath: "items[?spec.scaleTargetRef.kind=='Deployment' && spec.scaleTargetRef.name==deployment[0].metadata.name]"
      preconditions:
        all:
          - key: "{{ request.object.spec.selector.matchLabels | length(@) }}"
            operator: GreaterThan
            value: 0
          - key: "{{ hpa | length(@) }}"
            operator: Equals
            value: 0
          - key: "{{ deployment | length(@) }}"
            operator: GreaterThan
            value: 0
      validate:
        message: "PodDisruptionBudget minAvailable must be less than the Deployment replicas."
        deny:
          conditions:
            any:
              - key: "{{ request.object.spec.minAvailable }}"
                operator: GreaterThanOrEquals
                value: "{{ deployment[0].spec.replicas }}"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: deny-deployment-scale-below-pdb-minavailable
  annotations:
    policies.kyverno.io/title: Prevent scaling below PDB minAvailable
    policies.kyverno.io/category: Reliability
    policies.kyverno.io/severity: high
    policies.kyverno.io/description: >-
      Denies a Deployment scale operation that would set replicas less than or equal to a matching PodDisruptionBudget minAvailable.
spec:
  validationFailureAction: enforce
  background: false # subresources cannot be background scanned
  rules:
    - name: deny-deployment-scale-below-pdb-minavailable
      match:
        any:
        - resources:
            kinds:
            - Deployment/scale
            operations:
            - CREATE
            - UPDATE
      exclude:
        any:
        - resources:
            namespaces:
            - "kube-system"
      context:
        - name: deployment
          apiCall:
            urlPath: "/apis/apps/v1/namespaces/{{ request.namespace }}/deployments/{{ request.object.metadata.name }}"
            jmesPath: ""
        - name: pdbs
          apiCall:
            urlPath: "/apis/policy/v1/namespaces/{{ request.namespace }}/poddisruptionbudgets"
            jmesPath: "items[?spec.selector.matchLabels.app==deployment.spec.selector.matchLabels.app || spec.selector.matchLabels.\"app.kubernetes.io/name\"==deployment.spec.selector.matchLabels.\"app.kubernetes.io/name\"]"
      preconditions:
        all:
          - key: "{{ pdbs | length(@) }}"
            operator: GreaterThan
            value: 0
          - key: "{{ request.object.spec.replicas }}"
            operator: NotEquals
            value: ""
      validate:
        message: "Cannot scale Deployment replicas to a value <= PodDisruptionBudget minAvailable."
        deny:
          conditions:
            any:
              - key: "{{ request.object.spec.replicas }}"
                operator: LessThan
                value: "{{ pdbs[0].spec.minAvailable }}"
              - key: "{{ request.object.spec.replicas }}"
                operator: Equals
                value: "{{ pdbs[0].spec.minAvailable }}"
