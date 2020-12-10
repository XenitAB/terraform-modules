# EKS Cluster
resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iamRoleEksCluster.name
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iamRoleEksCluster.name
}

# EKS Node Group
resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iamRoleEksNodeGroup.name
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iamRoleEksNodeGroup.name
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iamRoleEksNodeGroup.name
}
