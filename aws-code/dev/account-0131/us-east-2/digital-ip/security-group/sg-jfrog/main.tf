data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}



resource "aws_security_group" "jfrog-sg" {
  name        = "sg_for_jfrog_${var.env_name}_${var.project_name}"
  description = "Jenkins nexus security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    #description = ""
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    #description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"
    ]
  }

  ingress {
    #description = ""
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"
    ]
  }

  ingress {
    #description = ""
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"
    ]
  }

  ingress {
    #description = "ports for alb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_for_jfrog_${var.env_name}_${var.project_name}"
  }
}