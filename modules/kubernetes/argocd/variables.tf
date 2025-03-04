variable "argocd_config" {
  description = "ArgoCD configuration"
  type = object({
    aad_group_name           = optional(string, "az-sub-xks-all-owner")
    application_set_replicas = optional(number, 2)
    controller_min_replicas  = optional(number, 1)
    repo_server_min_replicas = optional(number, 2)
    server_min_replicas      = optional(number, 2)
    redis_enabled            = optional(bool, true)
    global_domain            = string
    ingress_whitelist_ip     = string
    tenant                   = string
  })
}