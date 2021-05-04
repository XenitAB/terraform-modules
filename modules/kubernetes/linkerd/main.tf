/**
  * # Linkerd
  *
  * Adds [`linkerd`](https://github.com/linkerd/linkerd2) to a Kubernetes clusters.
  *
  * ## Additional information
  * 
  * ### Ingress configuration
  * 
  * ```YAML
  * apiVersion: extensions/v1beta1
  * kind: Ingress
  * [...]
  *   annotations:
  *     kubernetes.io/ingress.class: "nginx"
  *     nginx.ingress.kubernetes.io/configuration-snippet: |
  *       proxy_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
  *       grpc_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
  * ```
  *
  * Look at the [nginx](https://linkerd.io/2.10/tasks/using-ingress/#nginx) example for more information.
  *
  * ### Proxy injection
  *
  * Add the following annotation to your pod to inject the linkerd-proxy: `linkerd.io/inject: enabled`
  *
  * Look at the [docs](https://linkerd.io/2.10/tasks/adding-your-service/) for more information.
  * 
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

# Create namespaces
resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                                   = "linkerd"
      "xkf.xenit.io/kind"                    = "platform"
      "config.linkerd.io/admission-webhooks" = "disabled"
    }
    name = "linkerd"
  }
}

resource "kubernetes_namespace" "cni" {
  metadata {
    labels = {
      name                                   = "linkerd-cni"
      "xkf.xenit.io/kind"                    = "platform"
      "config.linkerd.io/admission-webhooks" = "disabled"
      "linkerd.io/cni-resource"              = "true"
    }

    annotations = {
      "linkerd.io/inject" = "disabled"
    }

    name = "linkerd-cni"
  }
}

# Create self signed certificate for linkerd-trust-anchor: https://linkerd.io/2.10/tasks/automatically-rotating-control-plane-tls-credentials/
resource "tls_private_key" "linkerd_trust_anchor" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256" # P256 required by linkerd: https://github.com/linkerd/linkerd2/blob/b9aa32f9b20057c7166347825428e53525962b9c/pkg/issuercerts/issuercerts.go#L144-L146
}

resource "tls_self_signed_cert" "linkerd_trust_anchor" {
  key_algorithm         = tls_private_key.linkerd_trust_anchor.algorithm
  private_key_pem       = tls_private_key.linkerd_trust_anchor.private_key_pem
  validity_period_hours = 87600
  early_renewal_hours   = 78840
  is_ca_certificate     = true

  subject {
    common_name = "root.linkerd.cluster.local"
  }

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "kubernetes_secret" "linkerd_trust_anchor" {
  metadata {
    name      = "linkerd-trust-anchor"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  data = {
    "tls.crt" = tls_self_signed_cert.linkerd_trust_anchor.cert_pem
    "tls.key" = tls_private_key.linkerd_trust_anchor.private_key_pem
  }

  type = "kubernetes.io/tls"
}

# Create self signed certificate for webhook-issuer-tls: https://linkerd.io/2.10/tasks/automatically-rotating-webhook-tls-credentials/
resource "tls_private_key" "webhook_issuer_tls" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256" # P256 required by linkerd: https://github.com/linkerd/linkerd2/blob/b9aa32f9b20057c7166347825428e53525962b9c/pkg/issuercerts/issuercerts.go#L144-L146
}

resource "tls_self_signed_cert" "webhook_issuer_tls" {
  key_algorithm         = tls_private_key.webhook_issuer_tls.algorithm
  private_key_pem       = tls_private_key.webhook_issuer_tls.private_key_pem
  validity_period_hours = 87600
  early_renewal_hours   = 78840
  is_ca_certificate     = true

  subject {
    common_name = "webhook.linkerd.cluster.local"
  }

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "kubernetes_secret" "webhook_issuer_tls" {
  metadata {
    name      = "webhook-issuer-tls"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  data = {
    "tls.crt" = tls_self_signed_cert.webhook_issuer_tls.cert_pem
    "tls.key" = tls_private_key.webhook_issuer_tls.private_key_pem
  }

  type = "kubernetes.io/tls"
}

# Install linkerd-cni helm chart
locals {
  values_cni = templatefile("${path.module}/templates/values-cni.yaml.tpl", {})
}
resource "helm_release" "linkerd_cni" {
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2-cni"
  name       = "linkerd-cni"
  namespace  = kubernetes_namespace.cni.metadata[0].name
  version    = "2.10.1"
  values     = [local.values_cni]
}

# Install linkerd helm charts
resource "helm_release" "linkerd_extras" {
  depends_on = [
    kubernetes_secret.linkerd_trust_anchor,
    kubernetes_secret.webhook_issuer_tls
  ]

  chart     = "${path.module}/charts/linkerd-extras"
  name      = "linkerd-extras"
  namespace = kubernetes_namespace.this.metadata[0].name
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    linkerd_trust_anchor_pem = indent(2, tls_self_signed_cert.linkerd_trust_anchor.cert_pem),
    webhook_issuer_pem       = indent(4, tls_self_signed_cert.webhook_issuer_tls.cert_pem),
  })
}

resource "helm_release" "linkerd" {
  depends_on = [helm_release.linkerd_extras, helm_release.linkerd_cni]

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2"
  name       = "linkerd"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "2.10.1"
  values     = [local.values]
}
