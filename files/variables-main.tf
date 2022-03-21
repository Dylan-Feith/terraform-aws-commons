# Variables
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
locals {
  current_region     = data.aws_region.current.name
  current_account_id = data.aws_caller_identity.current.account_id
  current_profile    = var.globalenv == "prod" ? var.aws_prod_profile : var.aws_nonprod_profile
}
output "region" {
  value = local.current_region
}

###################
### common vars ###
###################
variable "customer" {
  default = ""
}
output "customer" {
  value = var.customer
}

variable "project" {
  default = ""
}
output "project" {
  value = var.project
}

variable "project_cidr" {
  default = ""
}
output "project_cidr" {
  value = var.project_cidr
}

#################
### main vars ###
#################
variable "tfrun" {
  default = ""
}
output "tfrun" {
  value = var.tfrun
}

variable "globalenv" {
  default = ""
}
output "globalenv" {
  value = var.globalenv
}


variable "environment" {
  default = ""
}
output "environment" {
  value = var.environment
}

################
###  others  ###
################
variable "ttl_dns" {
  default = 600
}

variable "ec2_keyname" {
  default = "keenobi"
}

variable "root_domain_name" {
  default = "aws.keenobi.com"
}

###############
### profile ###
###############
variable "aws_profile" {
  default = ""
}
output "aws_profile" {
  value = var.aws_profile
}

variable "aws_nonprod_profile" {
  default = ""
}
output "aws_nonprod_profile" {
  value = var.aws_nonprod_profile
}

variable "aws_prod_profile" {
  default = ""
}
output "aws_prod_profile" {
  value = var.aws_prod_profile
}

variable "aws_nonprod_account_id" {
  default = ""
}
output "aws_nonprod_account_id" {
  value = var.aws_nonprod_account_id
}

variable "aws_prod_account_id" {
  default = ""
}
output "aws_prod_account_id" {
  value = var.aws_prod_account_id
}
