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
  * The [Linkerd CNI](https://linkerd.io/2.10/features/cni/) is required to if the linkerd-proxy sidecar isn't allowed to be root, which happens if using Gatekeeper.
  *
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
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
  private_key_pem       = tls_private_key.linkerd_trust_anchor.private_key_pem
  validity_period_hours = 87600
  early_renewal_hours   = 8760
  is_ca_certificate     = true

  subject {
    common_name         = "root.linkerd.cluster.local"
    country             = ""
    locality            = ""
    organization        = ""
    organizational_unit = ""
    postal_code         = ""
    province            = ""
    serial_number       = ""
    street_address      = []
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
  private_key_pem       = tls_private_key.webhook_issuer_tls.private_key_pem
  validity_period_hours = 87600
  early_renewal_hours   = 8760
  is_ca_certificate     = true

  subject {
    common_name         = "webhook.linkerd.cluster.local"
    country             = ""
    locality            = ""
    organization        = ""
    organizational_unit = ""
    postal_code         = ""
    province            = ""
    serial_number       = ""
    street_address      = []
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

# Install linkerd helm charts
resource "helm_release" "linkerd_extras" {
  depends_on = [
    kubernetes_secret.linkerd_trust_anchor,
    kubernetes_secret.webhook_issuer_tls
  ]

  chart       = "${path.module}/charts/linkerd-extras"
  name        = "linkerd-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
}

#tf-latest-version:ignore
resource "helm_release" "linkerd" {
  depends_on = [helm_release.linkerd_extras]

  repository  = "https://helm.linkerd.io/stable"
  chart       = "linkerd-control-plane"
  name        = "linkerd"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "1.9.4"
  max_history = 3
  values = [
    templatefile("${path.module}/templates/values.yaml.tpl", {
      linkerd_trust_anchor_pem = indent(2, tls_self_signed_cert.linkerd_trust_anchor.cert_pem),
      webhook_issuer_pem       = indent(4, tls_self_signed_cert.webhook_issuer_tls.cert_pem),
    }),
  ]
}

# Install linkerd viz extension https://github.com/linkerd/linkerd2/tree/main/viz/charts/linkerd-viz
#tf-latest-version:ignore
resource "helm_release" "linkerd_viz" {
  depends_on = [helm_release.linkerd]

  repository  = "https://helm.linkerd.io/stable"
  chart       = "linkerd-viz"
  name        = "linkerd-viz"
  namespace   = kubernetes_namespace.viz.metadata[0].name
  version     = "30.3.4"
  max_history = 3
  values = [
    templatefile("${path.module}/templates/values-viz.yaml.tpl", {}),
  ]
}
