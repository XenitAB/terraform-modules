# Migration: Azure Key Vault access policies → RBAC authorization

## Background

Microsoft has been steering customers away from Key Vault access policies for
several years. The official guidance is that **Azure RBAC is the recommended
permission model for new Key Vaults**: it integrates with Privileged Identity
Management, supports deny assignments, scales beyond the 1024-entry access
policy limit, and uses the same identity plane as the rest of Azure. Access
policies still work, but are effectively in maintenance mode. New code in this
repository should default to RBAC where possible, and existing vaults should be
migrated opportunistically.

## What changed in this repo

An opt-in flag has been added to a number of modules that either create a Key
Vault or grant an identity access to a Key Vault. When the flag is `true`, the
vault is created (or expected to be) with `enable_rbac_authorization = true`
and grants are issued as `azurerm_role_assignment` resources instead of
`azurerm_key_vault_access_policy` resources.

| Module | Variable / field | Default | Effect when `true` |
|---|---|---|---|
| [`modules/azure/governance-regional`](modules/azure/governance-regional) | per-vault field `key_vault_enable_rbac_authorization` inside `resource_group_configs` | `false` | Creates the delegated Key Vault with `enable_rbac_authorization = true` and switches its grants to `azurerm_role_assignment` |
| [`modules/azure/aks-regional`](modules/azure/aks-regional) | `key_vault_rbac_enabled` | `false` | xenit UAI gets `Key Vault Administrator` role instead of a full access policy |
| [`modules/azure/github-runner`](modules/azure/github-runner) | `key_vault_rbac_enabled` | `false` | VMSS identity gets `Key Vault Secrets User` instead of `secret_permissions = ["Get"]` |
| [`modules/kubernetes/argocd`](modules/kubernetes/argocd) | `key_vault_rbac_enabled` | `false` | argocd UAI gets `Key Vault Secrets User` + `Key Vault Crypto User` instead of an access policy |
| [`modules/kubernetes/datadog`](modules/kubernetes/datadog) | `key_vault_rbac_enabled` | `false` | datadog UAI gets `Key Vault Secrets User` |
| [`modules/kubernetes/grafana-k8s-monitoring`](modules/kubernetes/grafana-k8s-monitoring) | `key_vault_rbac_enabled` | `false` | grafana UAI gets `Key Vault Secrets User` |
| [`modules/kubernetes/grafana-k8s-monitoring-billable`](modules/kubernetes/grafana-k8s-monitoring-billable) | `key_vault_rbac_enabled` | `false` | billable grafana UAI gets `Key Vault Secrets User` |
| [`modules/kubernetes/aks-core`](modules/kubernetes/aks-core) | `key_vault_rbac_enabled` | `false` | Passes the flag through to the four kubernetes child modules above |

## Default behaviour

**All new variables default to `false`.** Existing deployments are unaffected
until you explicitly opt in. There is no implicit upgrade path; nothing happens
on `terraform apply` unless you set the flag.

## OpenTofu version requirement

The consumer modules use the [`enabled` meta-argument](https://opentofu.org/docs/v1.11/language/meta-arguments/enabled/)
(inside `lifecycle`) to toggle between the access policy and the role
assignment, which requires **OpenTofu ≥ 1.11.0**. All module `main.tf` files
in this repository now declare `required_version = ">= 1.11.0"`. If you pinned
an older OpenTofu in CI, bump it before consuming this version of the modules.

The `governance-regional` module keeps the toggle inside its existing
`for_each` filter (because `enabled` cannot be combined with `count` or
`for_each`), but the same minimum version still applies for consistency.

## The Azure constraint

A Key Vault is **either policy-mode or RBAC-mode at any given moment** — never
both. The mode is controlled by the vault property `enable_rbac_authorization`:

- `false` (default) — Azure evaluates `accessPolicies` on every data-plane call.
  Any role assignments on the vault scope still exist, but are *ignored* for
  data-plane authorization.
- `true` — Azure evaluates RBAC on every data-plane call. Any
  `accessPolicies` entries still exist in the resource definition, but are
  *ignored*.

The instant you flip the property, the *other* set of grants becomes
authoritative. This means:

1. The migration must be done **per vault**. You cannot half-migrate a vault.
2. If RBAC role assignments are not in place **before** you flip to RBAC mode,
   every identity that uses the vault will receive `403 Forbidden` until the
   role assignments are created and propagated (typically up to 5 minutes).
3. You can mix modes across vaults in the same environment freely.

## Role mapping rationale

The role assignments chosen by the modules above are deliberately close to the
permissions granted by the existing access policies:

- **`Key Vault Administrator`** is used for the owner identity in
  `aks-regional` (the xenit UAI). The pre-existing access policy granted the
  full secret / key / certificate permission set, and `Key Vault Administrator`
  is the closest single role. If you want least-privilege, you can swap it for
  a combination of `Key Vault Secrets Officer`, `Key Vault Crypto Officer` and
  `Key Vault Certificates Officer` after the migration is complete.
- **`Key Vault Secrets User`** is used wherever the previous access policy was
  only `secret_permissions = ["Get"]` (or equivalent read-only): `github-runner`
  VMSS, `datadog`, `grafana-k8s-monitoring`,
  `grafana-k8s-monitoring-billable`, and the secrets half of `argocd`. This is
  the documented minimum role to read secrets.
- **`Key Vault Crypto User`** is added for `argocd` because it also needs to
  unwrap keys.

Tightening to least-privilege roles later is a non-breaking change: you can
swap the role at any time without touching the vault's mode.

## Migration steps (delegated vault owned by `governance-regional`)

The example below assumes a vault entry inside `resource_group_configs`. The
consumer modules in this example are `aks-regional` and `argocd`; adjust as
needed.

### 1. Pre-grant equivalent RBAC roles while the vault is still in policy mode

Role assignments can be created on a policy-mode vault — they simply have no
effect until the vault flips. This is the safe way to avoid a 403 window.

Either run `az` out of band:

```sh
VAULT_ID=$(az keyvault show -n <vault-name> --query id -o tsv)

# xenit UAI from aks-regional
az role assignment create \
  --assignee-object-id <xenit-uai-principal-id> \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Administrator" \
  --scope "$VAULT_ID"

# argocd UAI
az role assignment create \
  --assignee-object-id <argocd-uai-principal-id> \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Secrets User" \
  --scope "$VAULT_ID"

az role assignment create \
  --assignee-object-id <argocd-uai-principal-id> \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Crypto User" \
  --scope "$VAULT_ID"
```

…or add a temporary Terraform block in your root module:

```hcl
resource "azurerm_role_assignment" "kv_pregrant_xenit" {
  scope                = data.azurerm_key_vault.delegated.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = module.aks_regional.xenit_identity_principal_id
}
```

### 2. Flip the vault to RBAC mode in `governance-regional`

```hcl
module "governance_regional" {
  source = "git::https://github.com/XenitAB/terraform-modules.git//modules/azure/governance-regional?ref=..."

  resource_group_configs = {
    "rg-platform" = {
      # ...existing fields...
      key_vault_enable_rbac_authorization = true
    }
  }
}
```

### 3. Update every consumer module pointing at that vault

```hcl
module "aks_regional" {
  source = "git::...//modules/azure/aks-regional?ref=..."

  key_vault_rbac_enabled = true
  # ...
}

module "aks_core" {
  source = "git::...//modules/kubernetes/aks-core?ref=..."

  key_vault_rbac_enabled = true   # fans out to argocd / datadog / grafana
  # ...
}
```

### 4. `terraform plan` and review

You should see, for the affected vault:

- `azurerm_key_vault.<name>` updated in place — `enable_rbac_authorization`
  flipping from `false` to `true`.
- `azurerm_key_vault_access_policy.*` resources for this vault **destroyed**.
- `azurerm_role_assignment.*` resources for this vault **created**.

If you see access policy resources being created for the same vault, or if you
see no role assignments at all, stop — something is wired wrong.

### 5. `terraform apply`

Apply during a window where a brief 403 burst is tolerable (RBAC propagation
is usually seconds, but can be up to ~5 minutes for new principals). The
pre-grants from step 1 should make this a non-event.

### 6. Clean up pre-grants

- If you used `az role assignment create`, either leave them (they will match
  what Terraform now manages and Terraform will start managing them on the
  next `terraform import`) or `terraform import` them into the module-managed
  resources.
- If you used a temporary `azurerm_role_assignment` block in your root, delete
  the block and apply. Terraform will see the role assignment already exists,
  managed by the module, and remove only the duplicate.

## Rollback

Rollback is symmetric and **does not require pre-grants**, because access
policies become effective the instant the vault flips back to policy mode and
the access policy resources are recreated by the same apply.

1. Set `key_vault_enable_rbac_authorization = false` on the vault entry in
   `resource_group_configs`.
2. Set `key_vault_rbac_enabled = false` on every consumer module pointing at
   that vault.
3. `terraform plan` — expect role assignments destroyed, access policies
   created, vault flipped back.
4. `terraform apply`.

## FAQ

**Can I have some vaults on RBAC and others on policies in the same environment?**
Yes. The flag is per vault in `governance-regional` and per consumer module.
You can migrate one vault at a time.

**What about secrets written by `aks-regional` itself (e.g. `ssh.tf`, `eventhub.tf`)?**
Those resources use the *deployer's* identity (the principal running
`terraform apply`), not the xenit UAI. The deployer therefore needs equivalent
permissions in whichever mode the vault is currently in:

- Policy mode: an access policy granting `secret_permissions = ["Set", "Get", "Delete", "Purge", "Recover"]` (or whatever the resource needs).
- RBAC mode: a role assignment such as `Key Vault Secrets Officer` (or
  `Key Vault Administrator` for parity with the previous deployer setup).

If your CI principal already has subscription-level `Owner` or `Contributor`,
note that `Contributor` does **not** grant data-plane access in RBAC mode —
you must explicitly add a Key Vault data-plane role.

**What if I forget to pre-grant before flipping?**
Deployers and consumer identities will receive `403 Forbidden` on data-plane
calls (`GetSecret`, `SetSecret`, `UnwrapKey`, …) until the role assignments
created by the same `terraform apply` finish propagating — usually within a
minute, occasionally up to ~5 minutes for brand-new principals. Cluster
add-ons that retry (CSI driver, external-secrets, argocd) will self-heal once
RBAC propagates; one-shot deploy steps may need to be re-run.
