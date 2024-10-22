
variable "grafana_k8s_monitor_config" {
  description = "Configuration for the username and password"
  type = object({
    grafana_cloud_prometheus_host = string
    grafana_cloud_loki_host       = string
    grafana_cloud_tempo_host      = string
    azure_key_vault_name          = string
    include_namespaces            = string
    include_namespaces_piped      = string
    exclude_namespaces            = string
  })
  default = {
    grafana_cloud_prometheus_host = ""
    grafana_cloud_loki_host       = ""
    grafana_cloud_tempo_host      = ""
    azure_key_vault_name          = ""
    include_namespaces            = "aad-pod-identity,azad-kube-proxy,azure-metrics,calico-system,cert-manager,controle-plane-logs,falco,flux-system,gatekeeper-system,grafana-agent,grafana-k8s-monitoring,ingress-healthz,ingress-nginx,kube-node-lease,kube-public,kube-system,node-ttl,reloader,spegel,tigera-operator,trivy,vpa"
    include_namespaces_piped      = "aad-pod-identity|azad-kube-proxy|azure-metrics|calico-system|cert-manager|controle-plane-logs|falco|flux-system|gatekeeper-system|grafana-agent|grafana-k8s-monitoring|ingress-healthz|ingress-nginx|kube-node-lease|kube-public|kube-system|node-ttl|reloader|spegel|tigera-operator|trivy|vpa"
    exclude_namespaces            = ""
  }
}
variable "cluster_name" {
  description = "Unique identifier of the cluster across instances."
  type        = string
}
variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}
variable "key_vault_id" {
  description = "Core key vault id"
  type        = string
}
variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}
variable "location" {
  description = "The Azure region name."
  type        = string
}
