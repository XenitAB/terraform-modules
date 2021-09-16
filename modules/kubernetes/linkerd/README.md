# Linkerd

Adds [`linkerd`](https://github.com/linkerd/linkerd2) to a Kubernetes clusters.

## Additional information

### CLI Installation

To verify that everything is working, install the [linkerd cli](https://linkerd.io/2.10/reference/cli/install/) and run [`linkerd check`](https://linkerd.io/2.10/reference/cli/check/) when connected to the cluster. This tool can only be used by cluster admins with access to the `linkerd` namespace.

Expected warnings from `linkerd check`:

- issuer cert is valid for at least 60 days
  - using `cert-manager` and renewing certificates multiple times per day
- proxy-injector cert is valid for at least 60 days
  - using `cert-manager` and renewing certificates multiple times per day
- sp-validator cert is valid for at least 60 days
  - using `cert-manager` and renewing certificates multiple times per day
- pod injection disabled on kube-system
  - a namespaceSelector is added to exclude namespaces containing `control-plane=true`

### Proxy injection

Add the following annotation to your pod to inject the linkerd-proxy: `linkerd.io/inject: enabled`

Look at the [docs](https://linkerd.io/2.10/tasks/adding-your-service/) for more information.

### Ingress configuration

The following `configuration-snippet` is needed for all ingress objects (using `ingress-nginx`) that exposes PODs with `linkerd.io/inject: enabled`.

```YAML
apiVersion: extensions/v1beta1
kind: Ingress
[...]
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
      grpc_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
```

Look at the [nginx](https://linkerd.io/2.10/tasks/using-ingress/#nginx) example for more information.

### Linkerd CNI

The [Linkerd CNI](https://linkerd.io/2.10/features/cni/) is required to if the linkerd-proxy sidecar isn't allowed to be root, which happens if using OPA-Gatekeeper.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.4.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.linkerd](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.linkerd_cni](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.linkerd_extras](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.linkerd_viz](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.cni](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.viz](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_secret.linkerd_trust_anchor](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/secret) | resource |
| [kubernetes_secret.webhook_issuer_tls](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/secret) | resource |
| [tls_private_key.linkerd_trust_anchor](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [tls_private_key.webhook_issuer_tls](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [tls_self_signed_cert.linkerd_trust_anchor](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/self_signed_cert) | resource |
| [tls_self_signed_cert.webhook_issuer_tls](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/self_signed_cert) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
