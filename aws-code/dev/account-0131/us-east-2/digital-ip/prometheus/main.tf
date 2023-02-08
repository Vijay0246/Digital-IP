#https://www.fairwinds.com/blog/terraform-and-eks-a-step-by-step-guide-to-deploying-your-first-cluster
#Configure the AWS Provider
#============================================================================================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.57.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
    access_key = "AKIAV3QP7XCBTAXVUQMV"
  secret_key = "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"
}
#================================================================================================================================================
locals {
  cluster_name = "digital-ip-prometheus"
}

module "vpc" {
  source = "git::https://git@github.com/reactiveops/terraform-vpc.git?ref=v5.0.1"

  aws_region = "us-east-1"
  az_count   = 2
  aws_azs    = "us-east-1a, us-east-1b"

  global_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}
#===========================================================================================================================================
module "eks" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v12.1.0"
  cluster_name = local.cluster_name
  vpc_id       = module.vpc.aws_vpc_id
  subnets      = module.vpc.aws_subnet_private_prod_ids

  node_groups = {
    eks_nodes = {
      desired_capacity = 1
      max_capacity     = 1
      min_capaicty     = 1

      instance_type = "t2.medium"
    }
  }

  manage_aws_auth = false
}
#==========================================================================================================================================
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.12"
}
#===========================================================================================================================================
#https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider?in=terraform/use-case
resource "kubernetes_namespace" "demo" {
  metadata {
    name = "monitoring"
  }
}
