data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "gitlab-runner-sg" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/security-group/sg-gitlab-runner/terraform.tfstate"
    region = "us-east-2"
  }
}


module "ec2" {
  source = "/Users/pavanwadhe/Downloads/Mouritech Work/Devops/terraform-module/ec2"

  instance_count = 1

  name          = "${var.project_name}-${var.env_name}"
  ami           = var.gitlab_runner_ami
  instance_type = var.gitlab_runner_instance_type
  key_name   = var.bastion_keypair_name

  subnet_ids     = tolist(data.terraform_remote_state.vpc.outputs.public_subnets)
  vpc_security_group_ids      = [data.terraform_remote_state.gitlab-runner-sg.outputs.id]
  associate_public_ip_address = true
  user_data = templatefile("${path.cwd}/install_gitlab_runner.sh", {})

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 50
    }

  ]

 tags = {
    "Env"      = var.env_name
    "project" = var.project_name
    "Name" = "gitlab-runner-for-${var.project_name}"
  }
}