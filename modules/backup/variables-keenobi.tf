variable "enabled" {
  type        = bool
  description = "Should we create all resources"
  default     = true
}

variable "name" {
  type        = string
  description = "Name to be given to resources"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
variable "backup_region_resource_type_opt_in_preference" {
  type = map(bool)
  default = {
    "Aurora"          = true
    "DocumentDB"      = true
    "DynamoDB"        = true
    "EBS"             = true
    "EC2"             = true
    "EFS"             = true
    "FSx"             = true
    "Neptune"         = true
    "RDS"             = true
    "S3"              = true
    "Storage Gateway" = true
    "DocumentDB"      = true
    "VirtualMachine"  = true
  }
}
variable "backup_region_resource_type_opt_in_preference_override" {
  type    = map(bool)
  default = {}
}

variable "backup_region_resource_type_management_preference" {
  default = {
    "DynamoDB" = true
    "EFS"      = true
  }
}
variable "backup_region_resource_type_management_preference_override" {
  type    = map(bool)
  default = {}
}
