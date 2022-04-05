variable "enabled" {
  type    = bool
  default = true
}
variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}
variable "accepter_subnets_filter" {
  type        = list(any)
  description = "A list of map to filter accepter subnets"
  default     = []
}
variable "requester_subnets_filter" {
  type        = list(any)
  description = "A list of map to filter accepter subnets"
  default     = []
}

