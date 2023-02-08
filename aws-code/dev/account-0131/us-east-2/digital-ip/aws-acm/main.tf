data "aws_route53_zone" "this" {
  count = var.use_existing_route53_zone ? 1 : 0

  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_zone" "this" {
  count = ! var.use_existing_route53_zone ? 1 : 0
  name  = var.domain_name
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}


module "acm" {


  source = "/mnt/c/Users/riyajk/Documents/devops/terraform-module/aws-acm"

  domain_name = var.domain_name
  zone_id     = coalescelist(data.aws_route53_zone.this.*.zone_id, aws_route53_zone.this.*.zone_id)[0]
 # zone_id = data.terraform_remote_state.vpc.outputs.
  subject_alternative_names = [
    "*.${var.domain_name}"

  ]

  wait_for_validation = true

  tags = {
    Name = var.domain_name
  }
}