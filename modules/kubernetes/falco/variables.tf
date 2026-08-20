variable "cilium_enabled" {
  description = "If enabled, will use Azure CNI with Cilium instead of kubenet"
  type        = bool
  default     = false
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "driver_kind" {
  description = "Which Falco driver to use. Falco 0.44 removed the legacy BPF probe, so the remaining options are modern_ebpf, kmod and auto."
  type        = string
  default     = "modern_ebpf"

  validation {
    condition     = contains(["modern_ebpf", "kmod", "auto"], var.driver_kind)
    error_message = "driver_kind must be one of modern_ebpf, kmod or auto."
  }
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}