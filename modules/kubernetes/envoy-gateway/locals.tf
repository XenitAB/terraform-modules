locals {
  envoy_gateway_require_tls = base64encode(
    templatefile("${path.module}/templates/envoy-gateway-require-tls.yaml.tpl", {
    })
  )
}
