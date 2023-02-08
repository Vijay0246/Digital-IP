data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "eks-cluster-sg" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/eks/eks-cluster/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "eks-nodes-sg" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/eks/sg-eks-nodes/terraform.tfstate"
    region = "us-east-2"
  }
}

module "mt_efs" {
    source = "/Users/pavanwadhe/Downloads/Mouritech Work/Devops/terraform-module/aws-efs"
    efs_name = "efs-nexus-eks"
    private_subnet_id_1 = data.terraform_remote_state.vpc.outputs.private_subnets[0]
    private_subnet_id_2 = data.terraform_remote_state.vpc.outputs.private_subnets[1]
    private_subnet_id_3 = data.terraform_remote_state.vpc.outputs.private_subnets[2]
    security_groups = [data.terraform_remote_state.eks-cluster-sg.outputs.sg-id,
    data.terraform_remote_state.eks-cluster-sg.outputs.cluster_security_group_id,
    data.terraform_remote_state.eks-nodes-sg.outputs.id]
}