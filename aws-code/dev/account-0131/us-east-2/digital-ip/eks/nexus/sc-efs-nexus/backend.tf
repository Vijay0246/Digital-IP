# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "mt-tfstate-dev-0131"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    key            = "terraform-code/dev/account-0131/us-east-2/digital-ip/eks/nexus/sc-efs-nexus/terraform.tfstate"
    region         = "us-east-2"
  }
}
