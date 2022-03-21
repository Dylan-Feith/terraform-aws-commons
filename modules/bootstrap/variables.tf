variable "customer" {}
variable "project" {}
variable "globalenv" {}

variable "main_region" {
  default = "eu-west-3"
}

variable "secondary_region" {
  default = "eu-west-1"
}

#variable "arn_format" {
#  type        = string
#  default     = "arn:aws"
#  description = "ARN format to be used. May be changed to support deployment in GovCloud/China regions."
#}
