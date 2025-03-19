/**
  * # Envoy Gateway
  *
  * This module is used to add [`envoy-gateway`](https://gateway.envoyproxy.io/docs/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
  }
}

resource "git_repository_file" "envoy_gateway" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/envoy-gateway.yaml"
  content = templatefile("${path.module}/templates/envoy-gateway.yaml.tpl", {
    envoy_gateway_config = var.envoy_gateway_config
    project              = var.fleet_infra_config.argocd_project_name
    server               = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "azurerm_policy_definition" "envoy_gateway_require_tls" {
  for_each = {
    for s in ["envoy_gateway"] :
    s => s
    if var.azure_policy_enabled
  }

  name         = "EnvoyGatewayRequireTLS"
  display_name = "Envoy Gatway must have traffic policy"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "in": [
          "Microsoft.ContainerService/managedClusters"
        ]
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "templateInfo": {
            "sourceType": "Base64Encoded",
            "content":  "${local.envoy_gateway_require_tls}" 
          },
          "apiGroups": [
            "gateway.envoyproxy"
          ],
          "kinds": [
            "ClientTrafficPolicy"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]"
        }
      }
    }
    POLICY_RULE

  # Not including labelSelector parameter
  parameters = <<PARAMETERS
    {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "'audit' allows a non-compliant resource to be created or updated, but flags it as non-compliant. 'deny' blocks the non-compliant resource creation or update. 'disabled' turns off the policy."
        },
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "defaultValue": "deny"
      },
      "excludedNamespaces": {
        "type": "Array",
        "metadata": {
          "displayName": "Namespace exclusions",
          "description": "List of Kubernetes namespaces to exclude from policy evaluation."
        },
        "defaultValue": []
      },
      "namespaces": {
        "type": "Array",
        "metadata": {
          "displayName": "Namespace inclusions",
          "description": "List of Kubernetes namespaces to only include in policy evaluation. An empty list means the policy is applied to all resources in all namespaces."
        },
        "defaultValue": []
      }
    }
    PARAMETERS
}

resource "azurerm_policy_set_definition" "tls" {
  for_each = {
    for s in ["envoy_gateway"] :
    s => s
    if var.azure_policy_enabled
  }

  name         = "XKSDefaultPolicySet"
  policy_type  = "Custom"
  description  = "This policy set defines a baseline standard for XKS tenant clusters"
  display_name = "Xenit Kubernetes Service baseline standards for XKS tenant clusters"

  metadata = <<METADATA
    {
      "category": "Kubernetes"
    }
    METADATA

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.envoy_gateway_require_tls[0].id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "namespaces": {
        "value": ${jsonencode(var.tenant_namespaces)}
      },
      "excludedNamespaces": {
        "value": "[concat(parameters('excludedNamespaces'))]"
      }
    }
    VALUE
  }
}

# TO-DO: There is a azurerm_resource_policy_assignment missing here.
