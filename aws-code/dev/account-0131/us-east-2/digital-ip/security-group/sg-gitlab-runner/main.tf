data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}



resource "aws_security_group" "gitlab-runner-sg" {
  name        = "sg_for_gitlab_runner_${var.env_name}_${var.project_name}"
  description = "gitlab-runner security group for dev environment"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  
  ingress {
    #description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_for_gitlab_runner_${var.env_name}_${var.project_name}"
  }
}