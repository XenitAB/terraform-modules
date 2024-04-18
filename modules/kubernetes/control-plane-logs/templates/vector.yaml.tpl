apiVersion: v1
kind: Namespace
metadata:
 name: controle-plane-logs
 labels:
   name              = "vector"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: vector
  namespace: controle-plane-logs
spec:
  interval: 1m0s
  url: "https://helm.vector.dev"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: vector
  namespace: controle-plane-logs
spec:
  chart:
    spec:
      chart: vector
      sourceRef:
        kind: HelmRepository
        name: vector
      version: v0.32.1
  interval: 1m0s
  values:
    role: "Stateless-Aggregator"
    podAnnotations:
      secret.reloader.stakater.com/reload: "vector"
    podLabels:
      aadpodidbinding: vector
    args:
      - "--config-dir=/config"
    env:
      - name: HOST
        valueFrom:
          configMapKeyRef:
            name: "vector"
            key: hostname
      - name: TOPIC
        valueFrom:
          configMapKeyRef:
            name: "vector"
            key: topic
      - name: PASSWORD
        valueFrom:
          secretKeyRef:
            name: "msg-queue"
            key: connectionstring
    extraVolumeMounts:
      - name: secret
        readOnly: true
        mountPath: "/config"
      - name: secret-store
        mountPath: "/mnt/secrets-store"
        readOnly: true
    extraVolumes:
      - name: secret
        configMap:
          name: "vector"
      - name: secret-store
        csi:
          driver: secrets-store.csi.k8s.io
          readOnly: true
          volumeAttributes:
            secretProviderClass: vector
    podSecurityContext:
      readOnlyRootFilesystem: true
      runAsNonRoot: true
      runAsUser: 1000
      capabilities:
        drop:
          - ALL