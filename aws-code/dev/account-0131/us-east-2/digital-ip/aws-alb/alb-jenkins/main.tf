data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "alb-jenkins-sg" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/security-group/sg-alb-jenkins/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "acm-arn" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/aws-acm/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "zone" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/aws-route53/zones/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "ec2-jenkins" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/ec2/ec2-jenkins-new/terraform.tfstate"
    region = "us-east-2"
  }
}
##################################################################
# Application Load Balancer
##################################################################
module "alb" {
  #source = "git@bitbucket.org:parkjockey/iac_modules.git//aws-alb"
  source = "/mnt/c/Users/riyajk/Documents/devops/terraform-module/aws-alb"

  name = "alb-for-jenkins-${var.project_name}"

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  security_groups = [data.terraform_remote_state.alb-jenkins-sg.outputs.id]
  subnets         = data.terraform_remote_state.vpc.outputs.public_subnets

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port = 80
      protocol = "HTTP"
      action_type = "redirect"
      redirect = {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }

  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.terraform_remote_state.acm-arn.outputs.this_acm_certificate_arn
      target_group_index = 0
      action_type        = "forward"
    },
  ]
  target_groups = [
    {
      #name_prefix          = "h1"
      name = "tg-for-jenkins-${var.project_name}"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/${module.alb.this_lb_arn}/login"
        port                = 8080
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "403"
      }
      tags = {
        InstanceTargetGroupTag = "tg-for-jenkins-${var.project_name}"
      }
    },

  ]

  tags = {
    Project = var.project_name
  }

  lb_tags = {
    MyLoadBalancer = "alb-for-jenkins-${var.project_name}"
  }

  target_group_tags = {
    MyGlobalTargetGroupTag = "tg-for-jenkins-${var.project_name}"
  }
}


resource "aws_alb_target_group_attachment" "alb-tg-jenkins-instance" {
  target_group_arn = module.alb.target_group_arns[0]
  port             = 8080
  target_id        = data.terraform_remote_state.ec2-jenkins.outputs.instance_id
}

resource "aws_route53_record" "cname_route53_record" {
  zone_id = data.terraform_remote_state.zone.outputs.this_route53_zone_zone_id["${var.domain_name}"]
  name    = "jenkins.${var.domain_name}"# Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "CNAME"
  ttl     = "60"
  records = [module.alb.this_lb_dns_name]
}


