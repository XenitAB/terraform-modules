/**
  * # Open Policy Agent Gatekeeper (opa-gatekeeper)
  *
  * This module is used to add [`opa-gatekeeper`](https://github.com/open-policy-agent/gatekeeper) to Kubernetes clusters.
  *
  * ## Details
  *
  * This module also adds opinionated defaults from the [`gatekeeper-library`](https://github.com/XenitAB/gatekeeper-library) that Xenit hosts (and aggregates the [`gatekeeper-library`](https://github.com/open-policy-agent/gatekeeper-library) OPA hosts).
  *
  * ## Example deployment
  * 
  * ```YAML
  * apiVersion: apps/v1
  * kind: Deployment
  * metadata:
  *   name: podinfo
  *   labels:
  *     app: podinfo
  * spec:
  *   replicas: 1
  *   strategy:
  *     type: RollingUpdate
  *     rollingUpdate:
  *       maxUnavailable: 1
  *   selector:
  *     matchLabels:
  *       app: podinfo
  *   template:
  *     metadata:
  *       labels:
  *         app: podinfo
  *     spec:
  *       terminationGracePeriodSeconds: 30
  *       containers:
  *         - name: podinfo
  *           image: "ghcr.io/stefanprodan/podinfo:5.0.3"
  *           imagePullPolicy: "IfNotPresent"
  *           command:
  *             - ./podinfo
  *             - --port=8080
  *             - --level=info
  *           env:
  *           - name: PODINFO_UI_MESSAGE
  *             value: "WELCOME TO PODINFO!"
  *           ports:
  *             - name: http
  *               containerPort: 8080
  *               protocol: TCP
  *           readinessProbe:
  *             exec:
  *               command:
  *               - podcli
  *               - check
  *               - http
  *               - localhost:8080/readyz
  *             initialDelaySeconds: 1
  *             timeoutSeconds: 5
  *           volumeMounts:
  *           - name: data
  *             mountPath: /data
  *           securityContext:
  *             allowPrivilegeEscalation: false
  *             readOnlyRootFilesystem: true
  *             capabilities:
  *               drop:
  *                 - NET_RAW
  *       volumes:
  *       - name: data
  *         emptyDir: {}
  * ```
  *
  * Required parts are `securityContext` and usually mounting an `emptyDir` to either a data directory or tmp.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

locals {
  gatekeeper_version         = "v3.2.1"
  gatekeeper_library_version = "v0.4.3"
  values                     = templatefile("${path.module}/templates/gatekeeper-library-values.yaml.tpl", { constraints = concat(var.default_constraints, var.additional_constraints), exclude = var.exclude })
}

resource "helm_release" "gatekeeper" {
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  name       = "gatekeeper"
  version    = local.gatekeeper_version
  values     = [file("${path.module}/files/gatekeeper-values.yaml")]
}

resource "helm_release" "gatekeeper_templates" {
  depends_on = [helm_release.gatekeeper]

  repository = "https://xenitab.github.io/gatekeeper-library/"
  chart      = "gatekeeper-library-templates"
  name       = "gatekeeper-library-templates"
  namespace  = "gatekeeper-system"
  version    = local.gatekeeper_library_version
  values     = [local.values]
}

resource "helm_release" "gatekeeper_constraints" {
  depends_on = [helm_release.gatekeeper, helm_release.gatekeeper_templates]

  repository = "https://xenitab.github.io/gatekeeper-library/"
  chart      = "gatekeeper-library-constraints"
  name       = "gatekeeper-library-constraints"
  namespace  = "gatekeeper-system"
  version    = local.gatekeeper_library_version
  values     = [local.values]
}
