apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: contour
  namespace: projectcontour
spec:
  interval: 1m0s
  url: "https://charts.bitnami.com/bitnami"
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: contour
  namespace: projectcontour
spec:
  chart:
    spec:
      chart: contour
      sourceRef:
        kind: HelmRepository
        name: contour
      version: 19.2.0
  interval: 1m0s
  values:
    contour:
      args:
        - "gateway-provisioner"
        - "--metrics-addr=127.0.0.1:8080"
        - "--enable-leader-election"
      extraEnvVars:
        - name: CONTOUR_PROVISIONER_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace

      replicaCount: ${contour_config.replica_count}
      priorityClassName: "platform-high"
      resourcesPreset: ${contour_config.resource_preset}
      podAntiAffinityPreset: "hard"
      pdb:
        create: true
        minAvailable: "1"
      envoy:
        enabled: falsekind: GatewayClass
---
apiVersion: gateway.networking.k8s.io/v1
metadata:
  name: contour-with-envoy-deployment
spec:
  controllerName: projectcontour.io/gateway-controller
  parametersRef:
    kind: ContourDeployment
    group: projectcontour.io
    name: contour-with-envoy-deployment-params
    namespace: projectcontour
---
kind: ContourDeployment
apiVersion: projectcontour.io/v1alpha1
metadata:
  namespace: projectcontour
  name: contour-with-envoy-deployment-params
spec:
  envoy:
    workloadType: Deployment
