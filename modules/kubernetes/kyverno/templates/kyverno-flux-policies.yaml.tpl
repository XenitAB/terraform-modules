apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: flux-require-service-account
  annotations:
    policies.kyverno.io/title: Flux Require Service Account
    policies.kyverno.io/category: Flux Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Flux HelmRelease and Kustomization resources should specify a serviceAccountName
      for security purposes.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-helm-release-service-account
    match:
      any:
      - resources:
          kinds:
          - HelmRelease
    exclude:
      any:
      - resources:
          namespaces:
          - "ambassador"
          - "flux-system"
    validate:
      message: "HelmRelease must specify a serviceAccountName"
      pattern:
        spec:
          serviceAccountName: "?*"
  - name: check-kustomization-service-account
    match:
      any:
      - resources:
          kinds:
          - Kustomization
    exclude:
      any:
      - resources:
          namespaces:
          - "ambassador"
          - "flux-system"
    validate:
      message: "Kustomization must specify a serviceAccountName"
      pattern:
        spec:
          serviceAccountName: "?*"
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: flux-disable-cross-namespace-source
  annotations:
    policies.kyverno.io/title: Flux Disable Cross Namespace Source
    policies.kyverno.io/category: Flux Security
    policies.kyverno.io/severity: high
    policies.kyverno.io/description: >-
      Flux HelmRelease and Kustomization resources should not reference sources
      in different namespaces for security purposes.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: check-helm-release-cross-namespace
    match:
      any:
      - resources:
          kinds:
          - HelmRelease
    exclude:
      any:
      - resources:
          namespaces:
          - "flux-system"
    validate:
      message: "HelmRelease cannot reference sources in different namespaces"
      deny:
        conditions:
          any:
          - key: "{{ request.object.spec.chart.spec.sourceRef.namespace || '' }}"
            operator: NotEquals
            value: "{{ request.namespace }}"
          - key: "{{ request.object.spec.chart.spec.sourceRef.namespace || '' }}"
            operator: NotEquals
            value: ""
  - name: check-kustomization-cross-namespace
    match:
      any:
      - resources:
          kinds:
          - Kustomization
    exclude:
      any:
      - resources:
          namespaces:
          - "flux-system"
    validate:
      message: "Kustomization cannot reference sources in different namespaces"
      deny:
        conditions:
          any:
          - key: "{{ request.object.spec.sourceRef.namespace || '' }}"
            operator: NotEquals
            value: "{{ request.namespace }}"
          - key: "{{ request.object.spec.sourceRef.namespace || '' }}"
            operator: NotEquals
            value: ""