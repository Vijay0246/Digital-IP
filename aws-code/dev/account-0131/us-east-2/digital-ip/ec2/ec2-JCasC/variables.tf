variable "env_name" {
  type        = string
  description = "Type of environment ex: dev, stage or prod"
}

variable "local_dir" {
  type        = string
  description = "local account directory name"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "aws_account_id" {
  type        = string
  description = "aws account id"
}
variable "project_name" {
  type        = string
  description = "project name"
}
variable "aws_account_short_id" {
  type = string
  description = "account short id"
}
variable "jcasc_ami" {
  type        = string
  description = " jcasc ami id"
}
variable "jcasc_instance_type" {
  type        = string
  description = "jcasc instance type"
}
variable "bastion_keypair_name" {
  type        = string
  description = " jcasc keypair name"
}

