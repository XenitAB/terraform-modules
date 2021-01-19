#cloud-config
write_files:
- content: |
    controller {
      name = "main"
      description = "Main Controller"
      database {
        url = "postgresql://${username}:${password}@${server}/${database}"
      }
    }

    listener "tcp" {
      address = "0.0.0.0"
      purpose = "api"
      tls_disable = true
      cors_enabled = true
      # change this to a proper domain
      cors_allowed_origins = ["*"]
    }

    listener "tcp" {
      address = "0.0.0.0"
      purpose = "cluster"
      tls_disable = true
    }

    kms "azurekeyvault" {
      purpose        = "root"
      tenant_id      = "${tenant_id}"
      vault_name     = "${key_vault_name}"
      key_name       = "${key_name_root}"
    }

    kms "azurekeyvault" {
      purpose        = "worker-auth"
      tenant_id      = "${tenant_id}"
      vault_name     = "${key_vault_name}"
      key_name       = "${key_name_worker_auth}"
    }
  path: /etc/boundary-controller.hcl
  owner: boundary
  group: boundary
