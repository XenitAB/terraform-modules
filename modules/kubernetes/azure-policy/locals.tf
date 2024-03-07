locals {
    azure_remove_node_spot_taints = base64encode(
        templatefile("${path.module}/templates/azure-remove-node-spot-taints.yaml.tpl", {
        })
    )
}