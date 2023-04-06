/**
  * # Datadog
  *
  * Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
  * This module is built to only gather application data.
  * API vs APP key.
  * API is used to send metrics to datadog from the agents.
  * APP key is used to be able to manage configuration inside datadog like alarms.
  * https://docs.datadoghq.com/account_management/api-app-keys/
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "xenitab/git"
      version = "0.0.1"
    }
  }
}
   
resource "git_repository_file" "kustomization" {
 path = "clsuters/we-dev-aks1/datadog.yaml"
 content = <<EOF
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: datadog
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./platform/we-dev-aks1/datadog
  prune: true
  validation: client
 EOF
}
   
resource "git_repository_file" "this" {
 path = "platform/we-dev-aks1/datadog/datadog.yaml"
 content = <<EOF
apiVersion: v1
kind: Namespace
metadata:
 name: datadog
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: datadog
  namespace: datadog
spec:
  interval: 1m0s
  url: "https://helm.datadoghq.com"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: datadog-operator
  namespace: datadog
spec:
  chart:
    spec:
      crds: CreateReplace
      chart: datadog-operator
      sourceRef:
        kind: HelmRepository
        name: datadog
      version: 0.8.0
    values:
      appKey: ${var.app_key}
      apiKey: ${var.api_key}
      installCRDs: false
      datadogMonitor:
        enabled: true
      resources:
        requests:
          cpu: 15m
          memory: 50Mi
  interval: 1m0s
---
apiVersion: datadoghq.com/v1alpha1
kind: DatadogAgent
metadata:
  name: datadog
  namespace: datadog
spec:
  clusterName: {{ .Values.clusterName }}
  site: {{ .Values.site }}
  credentials:
    apiSecret:
      secretName: datadog-operator-apikey
      keyName: api-key
    appSecret:
      secretName: datadog-operator-appkey
      keyName: app-key
  agent:
    priorityClassName: platform-high
    image:
      name: "gcr.io/datadoghq/agent:latest"
    log:
      enabled: true
      logsConfigContainerCollectAll: true
    apm:
      enabled: true
      hostPort: 8126
    env:
      - name: DD_CONTAINER_EXCLUDE_LOGS
        value: "name:datadog-agent"
      - name: DD_CONTAINER_INCLUDE
        value: {{ .Values.containerInclude }}
      - name: DD_CONTAINER_EXCLUDE
        value: "kube_namespace:.*"
      - name: DD_APM_IGNORE_RESOURCES
        value: {{ .Values.apmIgnoreResources }} 
    config:
      tolerations:
        - operator: Exists
      tags:
        - env:{{ .Values.environment }}
      kubelet:
        tlsVerify: false
      criSocket:
        criSocketPath: /var/run/containerd/containerd.sock
      volumeMounts:
        - name: containerdsocket
          mountPath: /var/run/containerd/containerd.sock
      volumes:
        - hostPath:
            path: /var/run/containerd/containerd.sock
          name: containerdsocket
        - hostPath:
            path: /var/run
          name: var-run
      resources:
        requests:
          cpu: 60m
          memory: 200Mi
  clusterAgent:
    replicas: 2
    priorityClassName: platform-low
    config:
      resources:
        requests:
          cpu: 60m
          memory: 200Mi
    image:
      name: "gcr.io/datadoghq/cluster-agent:latest"
  features:
    kubeStateMetricsCore:
      enabled: true
    logCollection:
      enabled: true
      logsConfigContainerCollectAll: true
 EOF
}

locals {
  container_filter_include = join(" ", formatlist("kube_namespace:%s", var.namespace_include))
  apm_ignore_resources     = join(",", formatlist("%s", var.apm_ignore_resources))
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    datadog_site             = var.datadog_site
    location                 = var.location
    environment              = var.environment
    container_filter_include = local.container_filter_include
    apm_ignore_resources     = local.apm_ignore_resources
  })
  values_datadog_operator = templatefile("${path.module}/templates/datadog-operator-values.yaml.tpl", {
    api_key = var.api_key
    app_key = var.app_key
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "datadog"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "datadog"
  }
}

resource "helm_release" "datadog_operator" {
  repository  = "https://helm.datadoghq.com"
  chart       = "datadog-operator"
  name        = "datadog-operator"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.8.0"
  max_history = 3
  values      = [local.values_datadog_operator]
}

resource "helm_release" "datadog_extras" {
  depends_on = [helm_release.datadog_operator]

  chart       = "${path.module}/charts/datadog-extras"
  name        = "datadog-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values      = [local.values]
}
