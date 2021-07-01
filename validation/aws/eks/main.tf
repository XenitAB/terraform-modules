terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "eks" {
  source = "../../../modules/aws/eks"

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
}
