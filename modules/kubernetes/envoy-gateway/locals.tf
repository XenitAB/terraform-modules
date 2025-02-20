locals {

  envoy_gateway_require_tls = base64encode(
    templatefile("${path.module}/templates/envoy_gateway_require_tls.yaml.tpl", {
    })
  )
}
