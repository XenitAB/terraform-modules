apiVersion: kyverno.io/v2alpha1
kind: MutatePolicy
metadata:
  name: remove-azure-spot-taints
  annotations:
    policies.kyverno.io/title: Remove Azure Spot Node Taints
    policies.kyverno.io/category: Azure
    policies.kyverno.io/severity: low
    policies.kyverno.io/description: >-
      Removes Azure spot node taints from nodes to allow proper scheduling.
spec:
  background: true
  rules:
  - name: remove-spot-taints
    match:
      any:
      - resources:
          kinds:
          - Node
    mutate:
      patchesJson6902: |-
        - path: "/spec/taints"
          op: remove
          value:
          - effect: NoSchedule
            key: kubernetes.azure.com/scalesetpriority
            value: spot
---
apiVersion: kyverno.io/v2alpha1
kind: MutatePolicy
metadata:
  name: mutate-deployment-replicas-based-on-pdb
  annotations:
    policies.kyverno.io/title: Mutate Deployment Replicas Based on PDB
    policies.kyverno.io/category: Reliability
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Ensures Deployments have at least minAvailable + 1 replicas when controlled by a PDB.
spec:
  mutateExistingOnPolicyUpdate: true
  background: true
  rules:
  - name: mutate-deployment-replicas
    match:
      any:
      - resources:
          kinds:
          - Deployment
    context:
    - name: pdbs
      apiCall:
        urlPath: "/apis/policy/v1/namespaces/{{ request.namespace }}/poddisruptionbudgets"
        jmesPath: "items[?spec.selector.matchLabels]"
    preconditions:
      all:
      - key: "{{ pdbs | length(@) }}"
        operator: GreaterThan
        value: 0
    mutate:
      forEach:
      - list: "{{ pdbs }}"
        preconditions:
          all:
          - key: "{{ element.spec.minAvailable }}"
            operator: NotEquals
            value: ""
          - key: "{{ request.object.spec.replicas || `1` }}"
            operator: LessThanOrEquals
            value: "{{ element.spec.minAvailable }}"
          # Check if deployment selector matches PDB selector
          - key: "{{ element.spec.selector.matchLabels | keys(@) }}"
            operator: AllIn
            value: "{{ request.object.spec.selector.matchLabels | keys(@) }}"
          - key: "{{ element.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
            operator: AllIn
            value: "{{ request.object.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
        patchStrategicMerge:
          spec:
            replicas: "{{ add(element.spec.minAvailable, `1`) }}"
---
apiVersion: kyverno.io/v2alpha1
kind: MutatePolicy
metadata:
  name: mutate-hpa-replicas-based-on-pdb
  annotations:
    policies.kyverno.io/title: Mutate HPA MinReplicas Based on PDB
    policies.kyverno.io/category: Reliability
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Ensures HPAs have minReplicas set to at least minAvailable + 1 when their target is controlled by a PDB.
spec:
  mutateExistingOnPolicyUpdate: true
  background: true
  rules:
  - name: mutate-hpa-minreplicas
    match:
      any:
      - resources:
          kinds:
          - HorizontalPodAutoscaler
    context:
    - name: deployment
      apiCall:
        urlPath: "/apis/apps/v1/namespaces/{{ request.namespace }}/deployments/{{ request.object.spec.scaleTargetRef.name }}"
        jmesPath: ""
    - name: pdbs
      apiCall:
        urlPath: "/apis/policy/v1/namespaces/{{ request.namespace }}/poddisruptionbudgets"
        jmesPath: "items[?spec.selector.matchLabels]"
    preconditions:
      all:
      - key: "{{ request.object.spec.scaleTargetRef.kind }}"
        operator: Equals
        value: "Deployment"
      - key: "{{ deployment }}"
        operator: NotEquals
        value: ""
      - key: "{{ pdbs | length(@) }}"
        operator: GreaterThan
        value: 0
    mutate:
      forEach:
      - list: "{{ pdbs }}"
        preconditions:
          all:
          - key: "{{ element.spec.minAvailable }}"
            operator: NotEquals
            value: ""
          - key: "{{ request.object.spec.minReplicas || `1` }}"
            operator: LessThanOrEquals
            value: "{{ element.spec.minAvailable }}"
          # Check if deployment selector matches PDB selector
          - key: "{{ element.spec.selector.matchLabels | keys(@) }}"
            operator: AllIn
            value: "{{ deployment.spec.selector.matchLabels | keys(@) }}"
          - key: "{{ element.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
            operator: AllIn
            value: "{{ deployment.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
        patchStrategicMerge:
          spec:
            minReplicas: "{{ add(element.spec.minAvailable, `1`) }}"
---
apiVersion: kyverno.io/v2alpha1
kind: GeneratePolicy
metadata:
  name: mutate-resources-on-pdb-changes
  annotations:
    policies.kyverno.io/title: Mutate Resources When PDB Changes
    policies.kyverno.io/category: Reliability
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Updates Deployments and HPAs when a PDB is created or updated, matching by label selectors.
spec:
  background: true
  rules:
  - name: update-deployments-on-pdb-change
    match:
      any:
      - resources:
          kinds:
          - PodDisruptionBudget
    context:
    - name: deployments
      apiCall:
        urlPath: "/apis/apps/v1/namespaces/{{ request.namespace }}/deployments"
        jmesPath: "items"
    preconditions:
      all:
      - key: "{{ request.object.spec.minAvailable }}"
        operator: NotEquals
        value: ""
      - key: "{{ request.object.spec.selector.matchLabels }}"
        operator: NotEquals
        value: ""
      - key: "{{ deployments | length(@) }}"
        operator: GreaterThan
        value: 0
    generate:
      forEach:
      - list: "{{ deployments }}"
        preconditions:
          all:
          # Check if deployment selector matches PDB selector
          - key: "{{ request.object.spec.selector.matchLabels | keys(@) }}"
            operator: AllIn
            value: "{{ element.spec.selector.matchLabels | keys(@) }}"
          - key: "{{ request.object.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
            operator: AllIn
            value: "{{ element.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
          - key: "{{ element.spec.replicas || `1` }}"
            operator: LessThanOrEquals
            value: "{{ request.object.spec.minAvailable }}"
        apiVersion: apps/v1
        kind: Deployment
        name: "{{ element.metadata.name }}"
        namespace: "{{ request.namespace }}"
        synchronize: true
        data:
          spec:
            replicas: "{{ add(request.object.spec.minAvailable, `1`) }}"
  - name: update-hpas-on-pdb-change
    match:
      any:
      - resources:
          kinds:
          - PodDisruptionBudget
    context:
    - name: deployments
      apiCall:
        urlPath: "/apis/apps/v1/namespaces/{{ request.namespace }}/deployments"
        jmesPath: "items"
    - name: hpas
      apiCall:
        urlPath: "/apis/autoscaling/v2/namespaces/{{ request.namespace }}/horizontalpodautoscalers"
        jmesPath: "items[?spec.scaleTargetRef.kind=='Deployment']"
    preconditions:
      all:
      - key: "{{ request.object.spec.minAvailable }}"
        operator: NotEquals
        value: ""
      - key: "{{ request.object.spec.selector.matchLabels }}"
        operator: NotEquals
        value: ""
      - key: "{{ deployments | length(@) }}"
        operator: GreaterThan
        value: 0
      - key: "{{ hpas | length(@) }}"
        operator: GreaterThan
        value: 0
    generate:
      forEach:
      - list: "{{ hpas }}"
        context:
        - name: targetDeployment
          variable:
            jmesPath: "deployments[?metadata.name=='{{ element.spec.scaleTargetRef.name }}'] | [0]"
            value: "{{ deployments }}"
        preconditions:
          all:
          - key: "{{ targetDeployment }}"
            operator: NotEquals
            value: ""
          # Check if target deployment selector matches PDB selector
          - key: "{{ request.object.spec.selector.matchLabels | keys(@) }}"
            operator: AllIn
            value: "{{ targetDeployment.spec.selector.matchLabels | keys(@) }}"
          - key: "{{ request.object.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
            operator: AllIn
            value: "{{ targetDeployment.spec.selector.matchLabels | to_entries(@) | map(&.value, @) }}"
          - key: "{{ element.spec.minReplicas || `1` }}"
            operator: LessThanOrEquals
            value: "{{ request.object.spec.minAvailable }}"
        apiVersion: autoscaling/v2
        kind: HorizontalPodAutoscaler
        name: "{{ element.metadata.name }}"
        namespace: "{{ request.namespace }}"
        synchronize: true
        data:
          spec:
            minReplicas: "{{ add(request.object.spec.minAvailable, `1`) }}"
