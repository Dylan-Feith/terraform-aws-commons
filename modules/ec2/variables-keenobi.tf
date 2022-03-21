# setup eip when associate_public_ip_address is true
variable "assign_eip_address" {
  description = "Assign an Elastic IP address to the instance"
  type        = bool
  default     = true
}

# create instance profile, role and dynamically attach policyes to the role
variable "permissions_boundary_arn" {
  description = "Policy ARN to attach to instance role as a permissions boundary"
  type        = string
  default     = ""
}
variable "policies_arn" {
  description = "List of policy ARNs to attach to instance"
  type        = list(string)
  default     = []
}
# add additionnal ebs
variable "additionnal_ebs_block_device" {
  description = "Map that contains additional ebs block to attach"
  type        = any
  default     = {}
}

# example
#additionnal_ebs_block_device = {
#  disk1_minimal = {
#    size        = 8
#    device_name = "sdb"
#  }
#  disk2_complete = {
#    # required
#    size        = 8
#    device_name = "sdb"
#    # optional
#    iops        = 3000
#    throughput  = "xxx"
#    type        = "gp3"
#    encrypted    = true
#    kms_key_id = data.aws_kms_key.ebs.arn
#  }
#}
