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
  type        = string
  description = "aws account short id"
}
variable "jenkins_master_ami" {
  type        = string
  description = "jenkins master ami id"
}
variable "jenkins_master_instance_type" {
  type        = string
  description = "jenkins master instance type"
}
variable "jenkins_master_keypair_name" {
  type        = string
  description = "jenkins master keypair name"
}
