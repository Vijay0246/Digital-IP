data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "bastion-sg" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/security-group/sg-bastion-host/terraform.tfstate"
    region = "us-east-2"
  }
}


module "ec2" {
  source = "/mnt/c/Users/riyajk/Documents/devops/terraform-module/ec2"

  instance_count = 1

  name          = "${var.project_name}-${var.env_name}"
  ami           = var.bastion_host_ami
  instance_type = var.bastion_instance_type
  key_name   = var.bastion_keypair_name

  subnet_ids     = tolist(data.terraform_remote_state.vpc.outputs.public_subnets)
  vpc_security_group_ids      = [data.terraform_remote_state.bastion-sg.outputs.id]
  associate_public_ip_address = true

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 8
    }

  ]

 tags = {
    "Env"      = var.env_name
    "project" = var.project_name
    "Name" = "bastion-host-for-${var.project_name}"
  }
}