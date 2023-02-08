data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "ec2-jenkins-sg" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/security-group/sg-jenkins-ec2/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_efs_file_system" "efs-jenkins" {
   #creation_token = "efs-example"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
      tags = {
          Name = "efs-for-jenkins-${var.project_name}-${var.env_name}"
   }
 }

 resource "aws_efs_mount_target" "efs-jenkins-mt" {
   file_system_id  = aws_efs_file_system.efs-jenkins.id
   subnet_id =  data.terraform_remote_state.vpc.outputs.private_subnets[0]

   security_groups = [aws_security_group.ingress-efs-jenkins.id]
 }

 resource "aws_security_group" "ingress-efs-jenkins" {
   name = "sg_for_efs_jenkins-${var.project_name}-${var.env_name}"
   vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

   // NFS
   ingress {
     security_groups = [data.terraform_remote_state.ec2-jenkins-sg.outputs.id]
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
   }

   // Terraform removes the default rule
   egress {
     security_groups = [data.terraform_remote_state.ec2-jenkins-sg.outputs.id]
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
 }