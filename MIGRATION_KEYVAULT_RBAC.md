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
Vault or grant an identity access to a Key Vault.

**RBAC role assignments are always created**, even when the flag is `false`.
While the target vault is still in access-policy mode, Azure ignores those
role assignments at the data plane, so they are functionally inert. This
lets operators pre-stage the role assignments (and let RBAC propagate) on one
apply, and then flip the vault to RBAC mode on a later apply for a
zero-downtime cutover.

When the flag is `true`:

- The matching `azurerm_key_vault_access_policy` resources are removed.
- On `governance-regional`, the delegated Key Vault is created with
  `enable_rbac_authorization = true`.
- The already-propagated role assignments take over authoritatively.

| Module | Variable / field | Default | Effect when `true` |
|---|---|---|---|
| [`modules/azure/governance-regional`](modules/azure/governance-regional) | per-vault field `key_vault_enable_rbac_authorization` inside `resource_group_configs` | `false` | Creates the delegated Key Vault with `enable_rbac_authorization = true` and removes the access policies on it (the six `Key Vault Administrator` role assignments are always created) |
| [`modules/azure/aks-regional`](modules/azure/aks-regional) | `key_vault_rbac_enabled` | `false` | Removes the xenit UAI access policy (its `Key Vault Administrator` role assignment is always created) |
| [`modules/azure/github-runner`](modules/azure/github-runner) | `key_vault_rbac_enabled` | `false` | Removes the VMSS identity access policy (its `Key Vault Secrets User` role assignment is always created) |
| [`modules/kubernetes/argocd`](modules/kubernetes/argocd) | `key_vault_rbac_enabled` | `false` | Removes the argocd UAI access policy (its `Key Vault Secrets User` + `Key Vault Crypto User` role assignments are always created) |
| [`modules/kubernetes/datadog`](modules/kubernetes/datadog) | `key_vault_rbac_enabled` | `false` | Removes the datadog UAI access policy (its `Key Vault Secrets User` role assignment is always created) |
| [`modules/kubernetes/grafana-k8s-monitoring`](modules/kubernetes/grafana-k8s-monitoring) | `key_vault_rbac_enabled` | `false` | Removes the grafana UAI access policy (its `Key Vault Secrets User` role assignment is always created) |
| [`modules/kubernetes/grafana-k8s-monitoring-billable`](modules/kubernetes/grafana-k8s-monitoring-billable) | `key_vault_rbac_enabled` | `false` | Removes the billable grafana UAI access policy (its `Key Vault Secrets User` role assignment is always created) |
| [`modules/kubernetes/aks-core`](modules/kubernetes/aks-core) | `key_vault_rbac_enabled` | `false` | Passes the flag through to the four kubernetes child modules above |

## Default behaviour

**All new variables default to `false`.** Existing deployments keep their
access policies and continue to operate in policy mode. Upgrading the module
version does, however, create the (inert) RBAC role assignments on the next
`tofu apply` — this is the intentional pre-staging described below.

## OpenTofu version requirement

The consumer modules use the [`enabled` meta-argument](https://opentofu.org/docs/v1.11/language/meta-arguments/enabled/)
(inside `lifecycle`) to disable the access policy when the vault is flipped to
RBAC mode (the paired role assignment is always created), which requires
**OpenTofu ≥ 1.11.0**. All module `main.tf` files
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

## Recommended migration steps (per vault)

### Step 1 — Pre-stage RBAC role assignments

Upgrade the module version and run `tofu apply`. This is a **zero-downtime
no-op** in terms of who can read the vault:

- `azurerm_role_assignment` resources are created on every delegated vault
  and by every consumer module that targets it.
- The vault is still in access-policy mode, so Azure ignores the new role
  assignments at the data plane. The existing access policies continue to
  authoritatively grant access.
- Wait a few minutes for RBAC propagation to complete (typically < 5 min,
  occasionally longer for brand-new principals).

No variables need to be set in this step — the role assignments are created
unconditionally.

### Step 2 — Flip the vault to RBAC

In a follow-up commit, set the RBAC opt-in flags:

- In `governance-regional`'s `resource_group_configs`, set
  `key_vault_enable_rbac_authorization = true` on the vault you want to flip.
- On every consumer module that targets that vault, set
  `key_vault_rbac_enabled = true`. For `aks-core` consumers, set it once on
  `aks-core` and it is wired through to all four kubernetes child modules
  (`argocd`, `datadog`, `grafana-k8s-monitoring`,
  `grafana-k8s-monitoring-billable`).

Then run `tofu apply`. In a single apply Azure flips the vault mode and the
access policies are removed; because the role assignments are already in
place and propagated, the cutover is instant.

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

## Rollback

Rollback is symmetric and **does not require pre-grants**, because access
policies become effective the instant the vault flips back to policy mode and
the access policy resources are recreated by the same apply.

1. Set `key_vault_enable_rbac_authorization = false` on the vault entry in
   `resource_group_configs`.
2. Set `key_vault_rbac_enabled = false` on every consumer module pointing at
   that vault.
3. `tofu plan` — expect access policies recreated and the vault flipped back
   to policy mode. The role assignments stay in place (they are always
   created) and become inert again.
4. `tofu apply`.

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

**What if I skip Step 1 and flip the vault to RBAC in a single apply?**
Deployers and consumer identities may receive `403 Forbidden` on data-plane
calls (`GetSecret`, `SetSecret`, `UnwrapKey`, …) until the role assignments
created by the same `tofu apply` finish propagating — usually within a
minute, occasionally up to ~5 minutes for brand-new principals. Cluster
add-ons that retry (CSI driver, external-secrets, argocd) will self-heal once
RBAC propagates; one-shot deploy steps may need to be re-run. The staged
two-step path in [Recommended migration steps](#recommended-migration-steps-per-vault)
exists specifically to avoid this window.
