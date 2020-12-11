resource "aws_eks_cluster" "this" {
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

  tags = {
    Name = "eks-${var.environment}-${var.locationShort}-${var.commonName}"
  }
}

resource "aws_eks_node_group" "this" {
  for_each = {
    for nodeGroup in var.eksConfiguration.nodeGroups :
    nodeGroup.name => nodeGroup
  }

  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodegroup-eks-${var.environment}-${var.locationShort}-${var.commonName}-${each.value.name}"
  node_role_arn   = aws_iam_role.iamRoleEksNodeGroup.arn
  instance_types  = each.value.instance_types
  disk_size       = each.value.disk_size
  subnet_ids = [
    data.aws_subnet.subnet1.id,
    data.aws_subnet.subnet2.id,
    data.aws_subnet.subnet3.id
  ]

  release_version = each.value.release_version

  scaling_config {
    desired_size = each.value.min_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.iamRolePolicyAttachmentAmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.iamRolePolicyAttachmentAmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.iamRolePolicyAttachmentAmazonEC2ContainerRegistryReadOnly
  ]

  tags = {
    Name = "nodegroup-eks-${var.environment}-${var.locationShort}-${var.commonName}-${each.value.name}"
  }
}

data "tls_certificate" "thumbprint" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.example.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}
