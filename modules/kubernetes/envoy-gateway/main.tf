/**
  * # Envoy Gateway
  *
  * This module is used to add [`envoy-gateway`](https://gateway.envoyproxy.io/docs/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
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

resource "kubernetes_namespace" "envoy_gateway" {
  metadata {
    name = "envoy-gateway"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/envoy-gateway.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "envoy_gateway" {
  path = "platform/${var.cluster_id}/envoy-gateway/envoy-gateway.yaml"
  content = templatefile("${path.module}/templates/envoy-gateway.yaml.tpl", {
    envoy_gateway_config = var.envoy_gateway_config
  })
}

resource "azurerm_policy_definition" "envoy_gateway_require_tls" {
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

resource "azurerm_policy_set_definition" "xks" {
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
    policy_definition_id = azurerm_policy_definition.envoy_gateway_require_tls.id
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
