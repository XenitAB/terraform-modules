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

  eks_authorized_ips = ["0.0.0.0/0"]
  eks_config = {
    version    = "1.21"
    cidr_block = "10.0.16.0/20"
    node_pools = [
      {
        name           = "standard"
        version        = "1.21.5-20220309"
        min_size       = 1
        max_size       = 3
        instance_types = ["t3.large"]
        node_labels    = {}
      },
    ]
  }
  cluster_role_arn    = "arn:partition:service:region:account-id:resource-id"
  node_group_role_arn = "arn:partition:service:region:account-id:resource-id"
  aws_kms_key_arn     = "arn:partition:service:region:account-id:resource-id"

  velero_config = {
    s3_bucket_arn = ""
    s3_bucket_id  = ""
  }
}
