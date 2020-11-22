resource "kubernetes_cluster_role" "list_namespaces" {
  metadata {
    name = "list-namespaces"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "helm_release" {
  metadata {
    name = "helm-release"
  }
  rule {
    api_groups = ["helm.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "tekton_edit" {
  for_each = {
    for s in ["tekton-operator"] :
    s => s
    if var.tekton_operator_enabled
  }

  metadata {
    name = "tekton-edit"
  }
  rule {
    api_groups = ["tekton.dev"]
    resources = [
      "tasks",
      "taskruns",
      "pipelines",
      "pipelineruns",
      "pipelineresources",
      "conditions"
    ]
    verbs = [
      "create",
      "delete",
      "deletecollection",
      "get",
      "list",
      "patch",
      "update",
      "watch"
    ]
  }
}

resource "kubernetes_cluster_role" "tekton_view" {
  for_each = {
    for s in ["tekton-operator"] :
    s => s
    if var.tekton_operator_enabled
  }

  metadata {
    name = "tekton-view"
  }
  rule {
    api_groups = ["tekton.dev"]
    resources = [
      "tasks",
      "taskruns",
      "pipelines",
      "pipelineruns",
      "pipelineresources",
      "conditions"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}
