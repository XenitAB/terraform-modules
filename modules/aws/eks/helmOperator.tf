# External DNS
data "aws_iam_policy_document" "iamPolicyDocumentHelmOperator" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::s3-${var.environment}-${var.locationShort}-${var.commonName}-helm/helm-charts/*"
    ]
  }
}

data "aws_iam_policy_document" "iamPolicyDocumentSaHelmOperator" {
  for_each = {
    for ns in var.namespaces :
    ns => ns
  }

  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.openIDProviderEks.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${each.key}:helm-operator"
      ]
    }

    principals {
      identifiers = [
        aws_iam_openid_connect_provider.openIDProviderEks.arn
      ]
      type = "Federated"
    }
  }
}

resource "aws_iam_policy" "iamPolicyHelmOperator" {
  for_each = {
    for ns in var.namespaces :
    ns => ns
  }

  name        = "iam-policy-eks-helm-operator"
  description = "A policy for helm-operator in EKS"

  policy = data.aws_iam_policy_document.iamPolicyDocumentHelmOperator.json
}

resource "aws_iam_role" "iamRoleSaHelmOperator" {
  for_each = {
    for ns in var.namespaces :
    ns => ns
  }

  assume_role_policy = data.aws_iam_policy_document.iamPolicyDocumentSaHelmOperator[each.key].json
  name               = "iam-role-eks-sa-helm-operator-${each.key}"
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentSaHelmOperator" {
  for_each = {
    for ns in var.namespaces :
    ns => ns
  }

  role       = aws_iam_role.iamRoleSaHelmOperator[each.key].name
  policy_arn = aws_iam_policy.iamPolicyHelmOperator[each.key].arn
}

resource "helm_release" "helmOperator" {
  for_each = {
    for ns in var.namespaces :
    ns => ns
  }

  name       = "helm-operator"
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  version    = "1.2.0"
  namespace  = each.key

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "helm-operator"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/iam-role-eks-sa-helm-operator-${each.key}"
  }

  set {
    name  = "allowNamespace"
    value = each.key
  }

  set {
    name  = "clusterRole.create"
    value = "false"
  }

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "initPlugins.enable"
    value = "true"
  }

  set {
    name  = "initPlugins.plugins[0].plugin"
    value = "https://github.com/hypnoglow/helm-s3.git"
  }

  set {
    name  = "extraEnvs[0].name"
    value = "AWS_DEFAULT_REGION"
  }

  set {
    name  = "extraEnvs[0].value"
    value = var.location
  }

  set {
    name  = "initPlugins.plugins[0].version"
    value = "0.9.2"
  }

  set {
    name  = "initPlugins.plugins[0].helmVersion"
    value = "v3"
  }

  depends_on = [
    kubernetes_namespace.namespace
  ]
}

# Aggregate CRD permissions to edit cluster role
resource "kubernetes_cluster_role" "helm_operator_crd_edit" {
  metadata {
    name = "aggregate-helm-operator-edit"
    labels = {
      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
    }
  }

  rule {
    api_groups = ["helm.fluxcd.io"]
    resources  = ["helmreleases"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}
