# Configure backend
terraform {
  required_version = "0.13.5"
  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

data "aws_iam_role" "iamRoleEksAdmin" {
  name = "iam-role-eks-admin"
}

data "aws_caller_identity" "current" {}

provider "aws" {
  alias   = "eksAdminRole"
  version = "~> 2.0"
  region  = "eu-west-1"
  assume_role {
    role_arn = data.aws_iam_role.iamRoleEksAdmin.arn
  }
}

data "aws_eks_cluster_auth" "eks" {
  provider = aws.eksAdminRole
  name     = aws_eks_cluster.eks.name
}

data "aws_secretsmanager_secret" "datadog_api_key" {
  name = "datadog-api-key"
}

data "aws_secretsmanager_secret_version" "datadog_api_key" {
  secret_id = data.aws_secretsmanager_secret.datadog_api_key.id
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks.token
    load_config_file       = false
  }
}
