mock_provider "azurerm" {}
mock_provider "git" {}

override_resource {
  target = azurerm_user_assigned_identity.arc
  values = {
    id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/arc-test"
    client_id    = "11111111-1111-1111-1111-111111111111"
    principal_id = "22222222-2222-2222-2222-222222222222"
  }
}

variables {
  aks_name            = "aks-test"
  cluster_id          = "remote-test-aks1"
  environment         = "test"
  location            = "swedencentral"
  location_short      = "sdc"
  oidc_issuer_url     = "https://oidc.invalid/arc-test"
  azure_tenant_id     = "00000000-0000-0000-0000-000000000000"
  key_vault_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv-test"
  resource_group_name = "rg-test"
  tenant_name         = "fixture"
  fleet_infra_config = {
    argocd_project_name = "fixture-test-platform"
    git_repo_url        = "https://git.invalid/fleet.git"
    k8s_api_server_url  = "https://remote-workload.invalid:6443"
  }
  arc_runner_set_config = {
    runner_scale_set_name      = "fixture-runners"
    github_config_url          = "https://github.com/fixture/repository"
    github_app_id              = "12345"
    github_app_installation_id = "67890"
    key_vault_name             = "kv-test"
  }
}

run "controller_only" {
  command = plan
  variables {
    arc_runner_set_config = null
  }
}

run "protect" {
  command = plan
  variables {
    arc_runner_set_config = {
      runner_scale_set_name       = "fixture-runners"
      github_config_url           = "https://github.com/fixture/repository"
      github_app_id               = "12345"
      github_app_installation_id  = "67890"
      key_vault_name              = "kv-test"
      credentials_migration_phase = "protect"
    }
  }
}

run "handoff" {
  command = plan
  variables {
    arc_runner_set_config = {
      runner_scale_set_name       = "fixture-runners"
      github_config_url           = "https://github.com/fixture/repository"
      github_app_id               = "12345"
      github_app_installation_id  = "67890"
      key_vault_name              = "kv-test"
      credentials_migration_phase = "handoff"
    }
  }
}

run "managed" {
  command = plan
  variables {
    arc_runner_set_config = {
      runner_scale_set_name       = "fixture-runners"
      github_config_url           = "https://github.com/fixture/repository"
      github_app_id               = "12345"
      github_app_installation_id  = "67890"
      key_vault_name              = "kv-test"
      credentials_migration_phase = "managed"
    }
  }
}

run "default_managed" {
  command = plan
}

run "invalid_phase" {
  command = plan
  variables {
    arc_runner_set_config = {
      runner_scale_set_name       = "fixture-runners"
      github_config_url           = "https://github.com/fixture/repository"
      github_app_id               = "12345"
      github_app_installation_id  = "67890"
      key_vault_name              = "kv-test"
      credentials_migration_phase = "invalid"
    }
  }
  expect_failures = [var.arc_runner_set_config]
}