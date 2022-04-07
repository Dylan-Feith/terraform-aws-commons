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
