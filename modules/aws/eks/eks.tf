resource "aws_eks_cluster" "eks" {
  provider = aws.eksAdminRole
  name     = "eks-${var.environment}-${var.locationShort}-${var.commonName}"
  role_arn = aws_iam_role.iamRoleEksCluster.arn
  version  = var.eksConfiguration.kubernetesVersion

  vpc_config {
    subnet_ids = [
      data.aws_subnet.subnet1.id,
      data.aws_subnet.subnet2.id,
      data.aws_subnet.subnet3.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.iamRolePolicyAttachmentAmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.iamRolePolicyAttachmentAmazonEKSServicePolicy
  ]

  tags = {
    Name = "eks-${var.environment}-${var.locationShort}-${var.commonName}"
  }
}

data "aws_region" "current" {}

data "external" "eksOidcThumbprint" {
  program = ["./files/oidc-thumbprint.sh", data.aws_region.current.name]
}

resource "aws_iam_openid_connect_provider" "openIDProviderEks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.eksOidcThumbprint.result.thumbprint]
  url             = aws_eks_cluster.eks.identity.0.oidc.0.issuer
}
