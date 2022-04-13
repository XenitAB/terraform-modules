/**
 * # Flux V2
 *
 * Installs and configures [flux2](https://github.com/fluxcd/flux2) with Azure DevOps.
 *
 * The module is meant to offer a full bootstrap and confiugration of a Kubernetes cluster
 * with Fluxv2. A "root" repository is created for the bootstrap configuration along with a
 * repository per namepsace passed in the variables. The root repository will receive `cluster-admin`
 * permissions in the cluster while each of the namespace repositories will be limited to their
 * repsective namespace. The CRDs, component deployments and bootstrap configuration are both
 * added to the Kubernetes cluster and commited to the root repository. While the namespace
 * configuration is only comitted to the root repository and expected to be reconciled through
 * the bootstrap configuration.
 *
 * ![flux-arch](../../../assets/fluxcd-v2.jpg)
 */

terraform {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  required_version = ">= 1.1.7"
=======
  required_version = "0.15.3"
>>>>>>> fe36c7a... Add initial config
=======
  required_version = "0.15.3"
>>>>>>> d074599... Add initial config
=======
  required_version = ">= 1.1.7"
>>>>>>> 3d1e125... Fix tf version
=======
  required_version = "0.15.3"
>>>>>>> Add initial config
=======
  required_version = "0.15.3"
>>>>>>> Add initial config
=======
  required_version = ">= 1.1.7"
>>>>>>> Fix tf version

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.5.1"
    }
    azuredevops = {
      source  = "xenitab/azuredevops"
      version = "0.5.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.0"
    }
  }
}

locals {
  git_auth_proxy_url = "http://git-auth-proxy.flux-system.svc.cluster.local"
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  fleet_infra_name   = "fleet-infra"
  branch_name        = "main"
=======
>>>>>>> Add initial config
=======
  fleet_infra_name = "fleet-infra"
  branch_name = "main"
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
  fleet_infra_name   = "fleet-infra"
  branch_name        = "main"
>>>>>>> make fmt & docs
=======
>>>>>>> fe36c7a... Add initial config
=======
  fleet_infra_name = "fleet-infra"
  branch_name = "main"
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
  fleet_infra_name   = "fleet-infra"
  branch_name        = "main"
>>>>>>> a69675f... make fmt & docs
=======
>>>>>>> d074599... Add initial config
=======
  fleet_infra_name = "fleet-infra"
  branch_name = "main"
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
  fleet_infra_name   = "fleet-infra"
  branch_name        = "main"
>>>>>>> f8311b7... make fmt & docs
=======
>>>>>>> Add initial config
=======
  fleet_infra_name = "fleet-infra"
  branch_name = "main"
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
  fleet_infra_name   = "fleet-infra"
  branch_name        = "main"
>>>>>>> make fmt & docs
=======
>>>>>>> Add initial config
=======
  fleet_infra_name = "fleet-infra"
  branch_name = "main"
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
  fleet_infra_name   = "fleet-infra"
  branch_name        = "main"
>>>>>>> make fmt & docs
}

resource "kubernetes_namespace" "this" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }

  metadata {
    name = "flux-system"
    labels = {
      name = "flux-system"
    }
  }
}

# Git Auth Proxy
resource "helm_release" "git_auth_proxy" {
  repository  = "https://xenitab.github.io/git-auth-proxy/"
  chart       = "git-auth-proxy"
  name        = "git-auth-proxy"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "v0.5.2"
  max_history = 3
  values = [templatefile("${path.module}/templates/git-auth-proxy-values.yaml.tpl", {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    credentials = var.credentials
    # TODO: change to not be fleet infra aware, instead it should just be one of the repositories
    fleet_infra = var.fleet_infra
    tenants     = var.namespaces
<<<<<<< HEAD
  })]
}

# Cluster
=======
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> Add initial config
=======
>>>>>>> Add initial config
    azure_devops_pat  = var.azure_devops_pat,
    azure_devops_org  = var.azure_devops_org,
    azure_devops_proj = var.azure_devops_proj,
    cluster_repo      = var.cluster_repo,
    github_org        = var.github_org
    app_id            = tonumber(var.github_app_id)
    installation_id   = tonumber(var.github_installation_id)
    private_key       = base64encode(var.github_private_key)
    tenants = [for ns in var.namespaces : {
      project : ns.flux.proj
      repo : ns.flux.repo
      namespace : ns.name
      }
      if ns.flux.enabled
    ],
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
    credentials = var.credentials
    # TODO: change to not be fleet infra aware, instead it should just be one of the repositories
    fleet_infra = var.fleet_infra
<<<<<<< HEAD
<<<<<<< HEAD
    tenants = var.namespaces
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
    tenants     = var.namespaces
>>>>>>> make fmt & docs
=======
    tenants     = var.namespaces
>>>>>>> a69675f... make fmt & docs
=======
>>>>>>> make fmt & docs
  })]
}

# Cluster
<<<<<<< HEAD
=======
=======
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
    credentials = var.credentials
    # TODO: change to not be fleet infra aware, instead it should just be one of the repositories
    fleet_infra = var.fleet_infra
<<<<<<< HEAD
<<<<<<< HEAD
    tenants = var.namespaces
<<<<<<< HEAD
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
    tenants     = var.namespaces
>>>>>>> make fmt & docs
  })]
}

# Cluster
<<<<<<< HEAD
>>>>>>> fe36c7a... Add initial config
=======
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
    tenants     = var.namespaces
>>>>>>> f8311b7... make fmt & docs
  })]
}

# Cluster
<<<<<<< HEAD
>>>>>>> d074599... Add initial config
=======
=======
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
    credentials = var.credentials
    # TODO: change to not be fleet infra aware, instead it should just be one of the repositories
    fleet_infra = var.fleet_infra
    tenants = var.namespaces
<<<<<<< HEAD
>>>>>>> Initial change of config to use one module - fluxcd-v2
  })]
}

# Cluster
<<<<<<< HEAD
>>>>>>> Add initial config
=======
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
  })]
}

# Cluster
<<<<<<< HEAD
>>>>>>> Add initial config
data "azuredevops_git_repository" "cluster" {
  project_id = data.azuredevops_project.this.id
  name       = var.cluster_repo
}

data "github_repository" "cluster" {
  full_name = "${var.github_org}/${var.cluster_repo}"
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
data "flux_install" "this" {
  target_path = "clusters/${var.cluster_id}"
}

data "flux_sync" "this" {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  # local var based on fleet infra type
  url         = var.fleet_infra.type == "azuredevops" ? "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}" : "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
  branch      = local.branch_name
  target_path = "clusters/${var.cluster_id}"
  # local var based on fleet infra type
  git_implementation = var.fleet_infra.type == "azuredevops" ? "libgit2" : "git2go"
=======
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> Add initial config
=======
>>>>>>> Add initial config
  url                = "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}"
  branch             = var.branch
  target_path        = "clusters/${var.cluster_id}"
  git_implementation = "libgit2"
}

data "flux_sync" "this" {
  url         = "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
  branch      = var.branch
  target_path = "clusters/${var.cluster_id}"
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Add initial config
=======
  # local var based on fleet infra type
  url         = var.fleet_infra.type == "azuredevops" ? "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}" : "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
  branch      = local.branch_name
  target_path = "clusters/${var.cluster_id}"
  # local var based on fleet infra type
  git_implementation = var.fleet_infra.type == "azuredevops" ? "libgit2" : "git2go"
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> fe36c7a... Add initial config
=======
  # local var based on fleet infra type
  url         = var.fleet_infra.type == "azuredevops" ? "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}" : "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
  branch      = local.branch_name
  target_path = "clusters/${var.cluster_id}"
  # local var based on fleet infra type
  git_implementation = var.fleet_infra.type == "azuredevops" ? "libgit2" : "git2go"
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> d074599... Add initial config
=======
  # local var based on fleet infra type
  url         = var.fleet_infra.type == "azuredevops" ? "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}" : "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
  branch      = local.branch_name
  target_path = "clusters/${var.cluster_id}"
  # local var based on fleet infra type
  git_implementation = var.fleet_infra.type == "azuredevops" ? "libgit2" : "git2go"
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
  # local var based on fleet infra type
  url         = var.fleet_infra.type == "azuredevops" ? "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}" : "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
  branch      = local.branch_name
  target_path = "clusters/${var.cluster_id}"
  # local var based on fleet infra type
  git_implementation = var.fleet_infra.type == "azuredevops" ? "libgit2" : "git2go"
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
  # local var based on fleet infra type
  url         = var.fleet_infra.type == "azuredevops" ? "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}" : "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
  branch      = local.branch_name
  target_path = "clusters/${var.cluster_id}"
  # local var based on fleet infra type
  git_implementation = var.fleet_infra.type == "azuredevops" ? "libgit2" : "git2go"
>>>>>>> Initial change of config to use one module - fluxcd-v2
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.this.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.this.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  depends_on = [kubernetes_namespace.this]
  lifecycle {
    prevent_destroy = true
  }
  for_each = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }

  yaml_body = each.value
}

resource "kubectl_manifest" "sync" {
  depends_on = [kubernetes_namespace.this]
  lifecycle {
    prevent_destroy = true
  }
  for_each = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }

  yaml_body = each.value
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
# Azure DevOps
data "azuredevops_project" "this" {
  name = var.azure_devops_proj
}
data "azuredevops_git_repository" "cluster" {
  project_id = data.azuredevops_project.this.id
  name       = var.cluster_repo
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
resource "azuredevops_git_repository_file" "install" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_install.this.path
  content             = data.flux_install.this.content
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "azuredevops_git_repository_file" "sync" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_sync.this.path
  content             = data.flux_sync.this.content
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "azuredevops_git_repository_file" "kustomize" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_sync.this.kustomize_path
  content             = file("${path.module}/templates/kustomization-override.yaml")
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "azuredevops_git_repository_file" "cluster_tenants" {
  repository_id = data.azuredevops_git_repository.cluster.id
  file          = "clusters/${var.cluster_id}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    cluster_id = var.cluster_id
  })
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
resource "azuredevops_git_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.type == "azuredevops"
  }

  repository_id = data.azuredevops_git_repository.cluster.id
  branch        = "refs/heads/${var.branch}"
  file          = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    repo        = "${local.git_auth_proxy_url}/${var.azure_devops_org}/${each.value.flux.proj}/_git/${each.value.flux.repo}"
    branch      = var.branch,
    name        = each.key,
    environment = var.environment,
    create_crds = each.value.flux.create_crds
  })
  overwrite_on_create = true
}

# GitHub
data "github_repository" "cluster" {
  full_name = "${var.github_org}/${var.cluster_repo}"
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
resource "github_repository_file" "install" {
  repository          = data.github_repository.cluster.name
  file                = data.flux_install.this.path
  content             = data.flux_install.this.content
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository          = data.github_repository.cluster.name
  file                = data.flux_sync.this.path
  content             = data.flux_sync.this.content
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository          = data.github_repository.cluster.name
  file                = data.flux_sync.this.kustomize_path
  content             = file("${path.module}/templates/kustomization-override.yaml")
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "cluster_tenants" {
  repository = data.github_repository.cluster.name
  file       = "clusters/${var.cluster_id}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    cluster_id = var.cluster_id
  })
  branch              = var.branch
  overwrite_on_create = true
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> Add initial config
=======
>>>>>>> Add initial config
# Tenants
resource "azuredevops_git_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  repository_id = data.azuredevops_git_repository.cluster.id
  branch        = "refs/heads/${var.branch}"
  file          = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    repo        = "${local.git_auth_proxy_url}/${var.azure_devops_org}/${each.value.flux.proj}/_git/${each.value.flux.repo}"
    branch      = var.branch,
    name        = each.key,
    environment = var.environment,
    create_crds = each.value.flux.create_crds
  })
  overwrite_on_create = true
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
resource "github_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    if ns.flux.type == "github"
=======
    if ns.flux.enabled
>>>>>>> Add initial config
=======
    if ns.flux.type == "github"
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
    if ns.flux.enabled
>>>>>>> fe36c7a... Add initial config
=======
    if ns.flux.type == "github"
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
    if ns.flux.enabled
>>>>>>> d074599... Add initial config
=======
    if ns.flux.type == "github"
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
    if ns.flux.enabled
>>>>>>> Add initial config
=======
    if ns.flux.type == "github"
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
    if ns.flux.enabled
>>>>>>> Add initial config
=======
    if ns.flux.type == "github"
>>>>>>> Initial change of config to use one module - fluxcd-v2
  }

  repository = data.github_repository.cluster.name
  branch     = var.branch
  file       = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    repo        = "${local.git_auth_proxy_url}/${var.github_org}/${each.value.flux.repo}.git"
    branch      = var.branch,
    name        = each.key,
    environment = var.environment,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    create_crds = each.value.flux.create_crds,
=======
    create_crds = false,
>>>>>>> Add initial config
=======
    create_crds = each.value.flux.create_crds,
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
    create_crds = false,
>>>>>>> fe36c7a... Add initial config
=======
    create_crds = each.value.flux.create_crds,
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
    create_crds = false,
>>>>>>> d074599... Add initial config
=======
    create_crds = each.value.flux.create_crds,
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
    create_crds = false,
>>>>>>> Add initial config
=======
    create_crds = each.value.flux.create_crds,
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
    create_crds = false,
>>>>>>> Add initial config
=======
    create_crds = each.value.flux.create_crds,
>>>>>>> Initial change of config to use one module - fluxcd-v2
  })
  overwrite_on_create = true
}
