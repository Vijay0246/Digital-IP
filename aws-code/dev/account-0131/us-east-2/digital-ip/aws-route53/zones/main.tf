module "zones" {

  source = "/mnt/c/Users/riyajk/Documents/devops/terraform-module/aws-route53/zones"

  zones = {
    "${var.domain_name}" = {
      comment = "${var.domain_name}"
      tags = {
        Name = "${var.domain_name}"
      }
    }

  }
}