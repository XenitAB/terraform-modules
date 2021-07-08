terraform {}

provider "aws" {
  region = "eu-west-1"
  alias  = "eks_admin"
}

provider "aws" {
  region = "eu-west-1"
}

module "eks" {
  source = "../../../modules/aws/eks"
  providers = {
    aws           = aws
    aws.eks_admin = aws.eks_admin
  }


  environment     = "dev"
  name            = "eks"
  eks_name_suffix = 1
  eks_config = {
    kubernetes_version = "1.20.4"
    cidr_block         = "10.0.16.0/20"
    node_groups = [
      {
        name            = "standard"
        release_version = "1.20.4"
        min_size        = 1
        max_size        = 3
        instance_types  = ["t3.large"]
      },
    ]
  }
  cluster_role_arn    = "arn:partition:service:region:account-id:resource-id"
  node_group_role_arn = "arn:partition:service:region:account-id:resource-id"
  aws_kms_key_arn     = "arn:partition:service:region:account-id:resource-id"
}
