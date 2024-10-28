/**
 * # Azure AD Kubernetes API Proxy
 * Adds [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy) to a Kubernetes clusters.
 *
 * # Terraform example (aks-core)
 *
 * module "aks_core" {
 *   source = "github.com/xenitab/terraform-modules//modules/kubernetes/aks-core?ref=[ref]"
 *
 *   [...]
 *
 *   azad_kube_proxy_enabled = true
 *   azad_kube_proxy_config = {
 *     fqdn                  = "aks.${var.dns_zone}"
 *     azure_ad_group_prefix = var.aks_group_name_prefix
 *     allowed_ips           = var.aks_authorized_ips
 *     azure_ad_app          = module.aks_global.azad_kube_proxy.azure_ad_app
 *   }
 * }
 * ```
 *
*/

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
    azurerm = {
      version = "4.7.0"
      source  = "hashicorp/azurerm"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/azad-kube-proxy.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "azad_kube_proxy" {
  path = "platform/${var.cluster_id}/azad-kube-proxy/azad-kube-proxy.yaml"
  content = templatefile("${path.module}/templates/azad-kube-proxy.yaml.tpl", {
    fqdn                    = var.fqdn,
    environment             = var.environment,
    location_short          = var.location_short,
    name                    = var.name,
    private_ingress_enabled = var.private_ingress_enabled,
    use_private_ingress     = var.use_private_ingress,
    allowed_ips_csv         = join(",", var.allowed_ips),
    azure_ad_group_prefix   = var.azure_ad_group_prefix,
    client_id               = module.azad_kube_proxy.data.client_id,
    client_secret           = module.azad_kube_proxy.data.client_secret,
    tenant_id               = module.azad_kube_proxy.data.tenant_id,
  })
}

resource "git_repository_file" "azure_config" {
  for_each = {
    for s in ["azure-config"] :
    s => s
  }

  path = "platform/${var.cluster_id}/azad-kube-proxy/azure-config.yaml"
  content = templatefile("${path.module}/templates/azure-config.yaml.tpl", {
    key_vault_name = var.key_vault_name,
    environment    = var.environment,
    location_short = var.location_short,
    name           = var.name,
    tenant_id      = azurerm_user_assigned_identity.azad_kube_proxy.tenant_id,
    client_id      = azurerm_user_assigned_identity.azad_kube_proxy.client_id,
  })
}

##moved from aks-regional
locals {
  azad_kube_proxy_url  = var.azad_kube_proxy_config.proxy_url_override == "" ? "https://aks-${var.location_short}.${var.dns_zones[0]}" : var.azad_kube_proxy_config.proxy_url_override
  azad_kube_proxy_name = "${var.azad_kube_proxy_config.cluster_name_prefix}-${var.environment}-${var.location_short}"
}

module "azad_kube_proxy" {
  source = "../../azure-ad/azad-kube-proxy"

  proxy_url    = local.azad_kube_proxy_url
  display_name = local.azad_kube_proxy_name
  cluster_name = local.azad_kube_proxy_name
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azad_kube_proxy" {
  name         = "azad-kube-proxy-${var.environment}-${var.location_short}-${var.name}"
  key_vault_id = var.key_vault_id
  value        = module.azad_kube_proxy.data.client_secret
  content_type = "string"
}
