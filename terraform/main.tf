terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-psp"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "aws_kms_key" "eks" {
  key_id = "alias/eks/devops-cluster"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "devops-cluster"
  cluster_version = "1.28"

  vpc_id     = "vpc-04d954b1c1bf4c257"
  subnet_ids = [
    "subnet-0de9d1596b0103733",
    "subnet-0d1f12312f2ef3149"
  ]

  create_kms_key = false

  cluster_encryption_config = {
    provider_key_arn = data.aws_kms_key.eks.arn
    resources        = ["secrets"]
  }

  cluster_enabled_log_types   = []
  create_cloudwatch_log_group = false

  eks_managed_node_groups = {
    devops = {
      desired_size   = 2
      min_size       = 1
      max_size       = 4
      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"
    }
  }
}
