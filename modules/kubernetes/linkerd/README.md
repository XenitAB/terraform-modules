# Linkerd

Adds [`linkerd`](https://github.com/linkerd/linkerd2) to a Kubernetes clusters.

## Additional information

### Ingress configuration

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

### Proxy injection

Add the following annotation to your pod to inject the linkerd-proxy: `linkerd.io/inject: enabled`

Look at the [docs](https://linkerd.io/2.10/tasks/adding-your-service/) for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.14.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.1.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.1.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.linkerd](https://registry.terraform.io/providers/hashicorp/helm/2.1.2/docs/resources/release) | resource |
| [helm_release.linkerd_cni](https://registry.terraform.io/providers/hashicorp/helm/2.1.2/docs/resources/release) | resource |
| [helm_release.linkerd_extras](https://registry.terraform.io/providers/hashicorp/helm/2.1.2/docs/resources/release) | resource |
| [kubernetes_namespace.cni](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/namespace) | resource |
| [kubernetes_secret.linkerd_trust_anchor](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/secret) | resource |
| [kubernetes_secret.webhook_issuer_tls](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/secret) | resource |
| [tls_private_key.linkerd_trust_anchor](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [tls_private_key.webhook_issuer_tls](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [tls_self_signed_cert.linkerd_trust_anchor](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/self_signed_cert) | resource |
| [tls_self_signed_cert.webhook_issuer_tls](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/self_signed_cert) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
