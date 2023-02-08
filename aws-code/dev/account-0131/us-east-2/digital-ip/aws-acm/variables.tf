variable "domain_name" {
  type        = string
  description = "domain name"
}

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

variable "use_existing_route53_zone" {
  type        = bool
  description = "existing route53_zone"
}

variable "aws_account_short_id" {
  type = string
  description = "account short id"
}