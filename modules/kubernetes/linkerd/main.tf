/**
  * # Linkerd
  *
  * Adds [`linkerd`](https://github.com/linkerd/linkerd2) to a Kubernetes clusters.
  *
  * ## Additional information
  *
  * ### CLI Installation
  *
  * To verify that everything is working, install the [linkerd cli](https://linkerd.io/2.10/reference/cli/install/) and run [`linkerd check`](https://linkerd.io/2.10/reference/cli/check/) when connected to the cluster. This tool can only be used by cluster admins with access to the `linkerd` namespace.
  *
  * Expected warnings from `linkerd check`:
  *
  * - issuer cert is valid for at least 60 days
  *   - using `cert-manager` and renewing certificates multiple times per day
  * - proxy-injector cert is valid for at least 60 days
  *   - using `cert-manager` and renewing certificates multiple times per day
  * - sp-validator cert is valid for at least 60 days
  *   - using `cert-manager` and renewing certificates multiple times per day
  * - pod injection disabled on kube-system
  *   - a namespaceSelector is added to exclude namespaces containing `control-plane=true`
  *
  * ### Proxy injection
  *
  * Add the following annotation to your pod to inject the linkerd-proxy: `linkerd.io/inject: enabled`
  *
  * Look at the [docs](https://linkerd.io/2.10/tasks/adding-your-service/) for more information.
  *
  * ### Ingress configuration
  *
  * The following `configuration-snippet` is needed for all ingress objects (using `ingress-nginx`) that exposes PODs with `linkerd.io/inject: enabled`.
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
  * ### Linkerd CNI
  *
  * The [Linkerd CNI](https://linkerd.io/2.10/features/cni/) is required to if the linkerd-proxy sidecar isn't allowed to be root, which happens if using OPA-Gatekeeper.
  *
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
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
      "control-plane"                        = "true"
    }
    name = "linkerd"
  }
}

# Information regarding cni namespace and the annotations and labels taken from: https://github.com/linkerd/linkerd2/blob/5f2d969cfac6ebc8893011eb120a32472a0648f3/charts/linkerd2-cni/templates/cni-plugin.yaml#L21-L29
resource "kubernetes_namespace" "cni" {
  metadata {
    labels = {
      name                                   = "linkerd-cni"
      "xkf.xenit.io/kind"                    = "platform"
      "config.linkerd.io/admission-webhooks" = "disabled"
      "linkerd.io/cni-resource"              = "true"
      "control-plane"                        = "true"
    }

    annotations = {
      "linkerd.io/inject" = "disabled"
    }

    name = "linkerd-cni"
  }
}

resource "kubernetes_namespace" "viz" {
  metadata {
    labels = {
      name                   = "linkerd-viz"
      "xkf.xenit.io/kind"    = "platform"
      "linkerd.io/extension" = "viz"
    }
    annotations = {
      "linkerd.io/inject"             = "enabled"
      "config.linkerd.io/proxy-await" = "enabled"
    }
    name = "linkerd-viz"
  }
}

# Create self signed certificate for linkerd-trust-anchor: https://linkerd.io/2.10/tasks/automatically-rotating-control-plane-tls-credentials/
resource "tls_private_key" "linkerd_trust_anchor" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256" # P256 required by linkerd: https://github.com/linkerd/linkerd2/blob/b9aa32f9b20057c7166347825428e53525962b9c/pkg/issuercerts/issuercerts.go#L144-L146
}

# More information regarding creating the trust anchor: https://linkerd.io/2.10/tasks/automatically-rotating-control-plane-tls-credentials/#cert-manager-as-an-on-cluster-ca
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

# More information regarding the webhook issuer: https://linkerd.io/2.10/tasks/automatically-rotating-webhook-tls-credentials/#save-the-signing-key-pair-as-a-secret
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
# Tmp use edge version until 2.11.0 is released where we will get the helm chart feature we need.
#tf-latest-version:ignore
resource "helm_release" "linkerd_cni" {
  repository = "https://helm.linkerd.io/edge"
  chart      = "linkerd2-cni"
  name       = "linkerd-cni"
  namespace  = kubernetes_namespace.cni.metadata[0].name
  version    = "21.7.5"

  values = [
    templatefile("${path.module}/templates/values-cni.yaml.tpl", {}),
  ]
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

resource "helm_release" "linkerd" {
  depends_on = [helm_release.linkerd_extras, helm_release.linkerd_cni]

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2"
  name       = "linkerd"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "2.10.2"
  values = [
    templatefile("${path.module}/templates/values.yaml.tpl", {
      linkerd_trust_anchor_pem = indent(2, tls_self_signed_cert.linkerd_trust_anchor.cert_pem),
      webhook_issuer_pem       = indent(4, tls_self_signed_cert.webhook_issuer_tls.cert_pem),
    }),
  ]
}

# Install linkerd viz extension https://github.com/linkerd/linkerd2/tree/main/viz/charts/linkerd-viz
resource "helm_release" "linkerd_viz" {
  depends_on = [helm_release.linkerd]

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-viz"
  name       = "linkerd-viz"
  namespace  = kubernetes_namespace.viz.metadata[0].name
  version    = "2.10.2"
  values = [
    templatefile("${path.module}/templates/values-viz.yaml.tpl", {}),
  ]
}
