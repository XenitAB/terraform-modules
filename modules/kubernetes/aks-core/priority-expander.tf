locals {
  # Produces a map(string), e.g. {"10" : "[.*standard.*]", "20" : "[.*spot.*]"}
  priority_expander_config = var.priority_expander_config == null ? {} : { for k, v in var.priority_expander_config : k => format("%s%s%s", "[", join(",", v), "]") }
}

resource "kubectl_manifest" "priority_expander" {
  for_each = {
    for s in ["priority_expander"] :
    s => s
    if var.priority_expander_config != null
  }
  apply_only = true
  yaml_body = templatefile("${path.module}/templates/priority-expander.yaml.tpl", {
    priority_expander_config = local.priority_expander_config
  })
}
