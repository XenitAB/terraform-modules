/**
  * # Azure Policy
  *
  * Adds [`Azure Policy for Kubernetes`](https://github.com/Azure/azure-policy) to a Kubernetes cluster.
  *
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.71.0"
      source  = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_policy_definition" "azure_remove_node_spot_taints" {
  name         = "AzureRemoveNodeSpotTaints"
  display_name = "Remove azure spot node taints"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "in": [
          "Microsoft.ContainerService/managedClusters"
        ]
      },
      "then": {
        "effect": "mutate",
        "details": {
          "mutationInfo": {
            "sourceType": "Base64Encoded",
            "content": "${local.azure_remove_node_spot_taints}"
          }
        }
      }
    }
    POLICY_RULE
}

resource "azurerm_policy_definition" "k8s_block_node_port" {
  name         = "K8sBlockNodePort"
  display_name = "Block node port services"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
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
            "content": "${local.k8s_block_node_port}"
          },
          "apiGroups": [
            ""
          ],
          "kinds": [
            "Service"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]",
          "labelSelector": "[parameters('labelSelector')]"
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

resource "azurerm_policy_definition" "k8s_secrets_store_csi_unique_volume" {
  name         = "K8sSecretsStoreCsiUniqueVolumes"
  display_name = "Secrets store should use unique csi volumes"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
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
            "content": "${local.k8s_secrets_store_csi_unique_volume}" 
          },
          "apiGroups": [
            ""
          ],
          "kinds": [
            "Pod"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]",
          "labelSelector": "[parameters('labelSelector')]"
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

resource "azurerm_policy_definition" "flux_require_service_account" {
  name         = "FluxRequireServiceAccount"
  display_name = "Flux requires service account"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
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
            "content":  "${local.flux_require_service_account}" 
          },
          "apiGroups": [
            "helm.toolkit.fluxcd.io",
            "kustomize.toolkit.fluxcd.io"
          ],
          "kinds": [
            "HelmRelease",
            "Kustomization"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]",
          "labelSelector": "[parameters('labelSelector')]"
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

resource "azurerm_policy_definition" "k8s_pod_priority_class" {
  name         = "K8sPodPriorityClass"
  display_name = "K8s pods should use allowed priority classes"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
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
            "content": "${local.k8s_pod_priority_class}"
          },
          "apiGroups": [
            ""
          ],
          "kinds": [
            "Pod"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]",
          "labelSelector": "[parameters('labelSelector')]",
          "values": {
            "permittedClassNames": "[parameters('permittedClassNames')]"
          }
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
      },
      "permittedClassNames": {
        "type": "Array",
        "metadata": {
          "displayName": "Permitted class name",
          "description": "Name of a permitted priority class"
        }
      }
    }
    PARAMETERS
}

resource "azurerm_policy_definition" "k8s_require_ingress_class" {
  name         = "K8sRequireIngressClass"
  display_name = "K8s ingresses should specify ingress class"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
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
            "content": "${local.k8s_require_ingress_class}"
          },
          "apiGroups": [
            "networking.k8s.io"
          ],
          "kinds": [
            "Ingress"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]",
          "labelSelector": "[parameters('labelSelector')]",
          "values": {
            "permittedClassNames": "[parameters('permittedClassNames')]"
          }
        }
      }
    }
    POLICY_RULE

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
      },
      "permittedClassNames": {
        "type": "Array",
        "metadata": {
          "displayName": "Permitted class name",
          "description": "Name of a permitted ingress class"
        }
      }
    }
    PARAMETERS
}

resource "azurerm_policy_definition" "flux_disable_cross_namespace_source" {
  name         = "FluxDisableCrossNamespaceSource"
  display_name = "Flux should disable cross namespace source"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
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
            "content": "${local.flux_disable_cross_namespace_source}"
          },
          "apiGroups": [
            "helm.toolkit.fluxcd.io",
            "kustomize.toolkit.fluxcd.io"
          ],
          "kinds": [
            "HelmRelease",
            "Kustomization"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]",
          "labelSelector": "[parameters('labelSelector')]"
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

resource "azurerm_policy_definition" "azure_identity_format" {
  name         = "AzureIdentityFormat"
  display_name = "Azure identity format"
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  policy_rule  = <<POLICY_RULE
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
            "content": "${local.azure_identity_format}" 
          },
          "apiGroups": [
            "aadpodidentity.k8s.io"
          ],
          "kinds": [
            "AzureIdentity"
          ],
          "namespaces": "[parameters('namespaces')]",
          "excludedNamespaces": "[parameters('excludedNamespaces')]",
          "labelSelector": "[parameters('labelSelector')]"
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

resource "azurerm_policy_definition" "mutations" {
  policy_type  = "Custom"
  mode         = "Microsoft.Kubernetes.Data"

  metadata = <<METADATA
    {
      "category": "XKS"
    }
    METADATA

  for_each = { for mutation in var.azure_policy_config.mutations : mutation.name => mutation }
  name         = "${each.key}"
  display_name = "${each.value.display_name}"
  policy_rule  = <<POLICY_RULE
  {
    "if": {
        "field": "type",
        "in": [
          "Microsoft.ContainerService/managedClusters"
        ]
      },
      "then": {
        "effect": "mutate",
        "details": {
          "mutationInfo": {
            "sourceType": "Base64Encoded",
            "content": "${filebase64("templates/${each.value.template}")}" 
          }
        }
      }
  }
  POLICY_RULE
}

resource "azurerm_policy_set_definition" "xks" {
  name         = "XKSDefaultPolicySet"
  policy_type  = "Custom"
  description  = "This policy set defines a baseline standard for XKS tenant clusters"
  display_name = "Xenit Kubernetes Service baseline standards for XKS tenant clusters"

  metadata   = <<METADATA
    {
      "category": "Kubernetes"
    }
    METADATA
    
  parameters = <<PARAMETERS
    {
      "allowedCapabilities": {
        "type": "Array",
        "metadata": {
          "displayName": "Allowed container capabilities",
          "description": "A list of allowed container capabilities."
        },
        "defaultValue": []
      },
      "allowedExternalIPs": {
        "type": "Array",
        "metadata": {
          "displayName": "External IPs",
          "description": "A list of allowed external IPs."
        },
        "defaultValue": []
      },
      "allowedVolumeTypes": {
        "type": "Array",
        "metadata": {
          "displayName": "Allowed volume types",
          "description": "List of Kubernetes allowed volume types to include in policy evaluation."
        },
        "defaultValue": []
      },
      "excludedNamespaces": {
        "type": "Array",
        "metadata": {
          "displayName": "Namespace exclusions",
          "description": "List of Kubernetes namespaces to exclude from policy evaluation."
        },
        "defaultValue": []
      },
      "excludedImages": {
        "type": "Array",
        "metadata": {
          "displayName": "Image exclusions",
          "description": "The list of InitContainers and Containers to exclude from policy evaluation. The identifier is the image of container. Prefix-matching can be signified with `*`."
        },
        "defaultValue": []
      },
      "requiredDropCapabilities": {
        "type": "Array",
        "metadata": {
          "displayName": "Disallowed container capabilities",
          "description": "A list of container capabilities that should be dropped."
        },
        "defaultValue": [
          "NET_RAW",
          "CAP_SYS_ADMIN"
        ]
      },
      "requiredProbes": {
        "type": "Array",
        "metadata": {
          "displayName": "Rquired probes",
          "description": "A list of required probes."
        },
        "defaultValue": [
          "readinessProbe"
        ]
      }
    }
    PARAMETERS

  # Custom definitions

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.azure_remove_node_spot_taints.id
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.k8s_block_node_port.id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'spegel',
              'tigera-operator'
            ]
          )
        ]"
      }
    }
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.k8s_secrets_store_csi_unique_volume.id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      }
    }
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.flux_require_service_account.id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'calico-system',
              'flux-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      },
      "labelSelector": {
        "matchLabels":
          "xkf.xenit.io/kind": "tenant"
      }
    }
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.k8s_pod_priority_class.id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'spegel',
              'tigera-operator'
            ]
          )
        ]"
      },
      "permittedClassNames": {
        "value": "[
          'platform-low',
          'platform-medium',
          'platform-high',
          'tenant-low',
          'tenant-medium',
          'tenant-high'
        ]"
      }
    }
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.k8s_require_ingress_class.id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      },
      "permittedClassNames": {
        "value": [
          'nginx',
          'nginx-private',
          'nginx-public'
        ]
      }
    }
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.flux_disable_cross_namespace_source.id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'calico-system',
              'flux-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      }
    }
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.azure_identity_format.id
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      }
    }
  }

  # Built-in definitions

  # Read-only root filesystem constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/df49d893-a74c-421d-bc95-c663042e5b80"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'ambassador',
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      },
      "excludedImages": {
        "value": "[
          concat(
            parameters('excludedImages'),
            [
              'ghcr.io/metalbear-co/mirrord:*'
            ]
          )
        ]"
      }
    }
    VALUE
  }
  
  # Flex volumes constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f4a8fce0-2dd5-4c21-9a36-8f0ec809d663"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'ambassador',
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      }
    }
    VALUE
  }
  
  # Container privilege escalation constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(
            parameters('excludedNamespaces'),
            [
              'aad-pod-identity',
              'ambassador',
              'calico-system',
              'cert-manager',
              'csi-secrets-store-provider-azure',
              'datadog',
              'external-dns',
              'falco',
              'flux-system',
              'gatekeeper-system',
              'ingress-nginx',
              'kube-system',
              'prometheus',
              'reloader',
              'spegel',
              'tigera-operator',
              'trivy',
              'vpa'
            ]
          )
        ]"
      },
       "excludedImages": {
        "value": "[parameters('excludedImages')]"
      }
    }
    VALUE
  }
  
  # Host process ID or host IPC namespace sharing constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/47a1ee2f-2a2a-4576-bf2a-e0e36709c2b8"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(parameters('excludedNamespaces'),
            [
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      },
      "excludedImages": {
        "value": "[
          concat(parameters('excludedImages'),
            [
              'ghcr.io/metalbear-co/mirrord:*'
            ]
          )
        ]"
      }
    }
    VALUE
  }
  
  # External IPs constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d46c275d-1680-448d-b2ec-e495a3b6cc89"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(parameters('excludedNamespaces'),
            [
              'calico-system',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      },
      "allowedExternalIPs": {
        "value": "[parameters('allowedExternalIPs')]"
      }
    }
    VALUE
  }
  
  # Host network constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/82985f06-dc18-4a48-bc1c-b9f4f0098cfe"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(parameters('excludedNamespaces'),
            [
              'aad-pod-identity',
              'calico-system',
              'csi-secrets-store-provider-azure',
              'gatekeeper-system',
              'kube-system',
              'prometheus',
              'tigera-operator'
            ]
          )
        ]"
      },
      "excludedImages": {
        "value": "[parameters('excludedImages')]"
      }
    }
    VALUE
  }
  
  # Volume types constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/16697877-1118-4fb1-9b65-9898ec2509ec"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(parameters('excludedNamespaces'),
            [
              'aad-pod-identity',
              'calico-system',
              'csi-secrets-store-provider-azure',
              'datadog',
              'falco',
              'gatekeeper-system',
              'kube-system',
              'prometheus',
              'promtail',
              'spegel',
              'tigera-operator'
            ]
          )
        ]"
      },
      "allowedVolumeTypes": {
        "value": "[
          concat(parameters('volumes'),
            [
              'configMap',
              'downwardAPI',
              'emptyDir',
              'persistentVolumeClaim',
              'secret',
              'projected',
              'csi'
            ]
          )
        ]"
      },
      "excludedImages": {
        "value": "[
          concat(
            parameters('excludedImages'),
            [
              'ghcr.io/metalbear-co/mirrord:*'
            ]
          )
        ]"
      }
    }
    VALUE
  }
  
  # Privileged container constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "excludedNamespaces": {
        "value": "[
          concat(parameters('excludedNamespaces'),
            [
              'calico-system',
              'csi-secrets-store-provider-azure',
              'falco',
              'gatekeeper-system',
              'kube-system',
              'tigera-operator'
            ]
          )
        ]"
      },
      "excludedImages": {
        "value": "[parameters('excludedImages')]"
      }
    }
    VALUE
  }
  
  # Container capabilities constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c26596ff-4d70-4e6a-9a30-c2506bd2f80c"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "deny"
      },
      "allowedCapabilities": {
        "[parameters('allowedCapabilities')]"
      },
      "requiredDropCapabilities": {
        "[parameters('requiredDropCapabilities')]"
      },
      "excludedNamespaces": {
        "value": "[
          concat(parameters('excludedNamespaces'),
            [
              'aad-pod-identity',
              'calico-system',
              'csi-secrets-store-provider-azure',
              'cert-manager',
              'datadog',
              'external-dns',
              'falco',
              'flux-system',
              'gatekeeper-system',
              'ingress-nginx',
              'kube-system',
              'prometheus',
              'promtail',
              'reloader',
              'spegel',
              'tigera-operator',
              'trivy',
              'vpa'
            ]
          )
        ]"
      },
      "excludedImages": {
        "value": "[
          concat(
            parameters('excludedImages'),
            [
              'docker.io/datawire/tel2:*',
              'ghcr.io/metalbear-co/mirrord:*'
            ]
          )
        ]"
      }
    }
    VALUE
  }
  
  # Required probes constraint
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b1a9997f-2883-4f12-bdff-2280f99b5915"
    parameter_values     = <<VALUE
    {
      "effect": {
        "value": "Audit"
      },
      "excludedNamespaces": {
        "value": "[parameters('excludedNamespaces')]"
      },
      "requiredProbes": {
        "[parameters('enforceProbes')]"
      }
    }
    VALUE
  }

  # All the mutations
  dynamic policy_definition_reference {
    for_each = { for mutation in var.azure_policy_config.mutations : mutation.name => mutation }
    
    content {
      policy_definition_id = azurerm_policy_definition.mutations["${each.key}"].id
    }
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.aks_name}"
}

data "azurerm_kubernetes_cluster" "this" {
  resource_group_name = data.azurerm_resource_group.this.name
  name                = "aks-${var.environment}-${var.location_short}-${var.aks_name}"
}

resource "azurerm_resource_policy_assignment" "this" {
  name                 = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-assignment"
  resource_id          = azurerm_kubernetes_cluster.this.id
  policy_definition_id = azurerm_policy_set_definition.xks.id
}


