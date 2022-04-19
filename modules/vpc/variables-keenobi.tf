variable "enable_nat_instance" {
  description = "Allow to use a nat instance as the default route"
  type        = bool
  default     = false
}

variable "nat_instance_destination_cidr_block" {
  description = "Used to pass a custom destination route for private NAT instance. If not specified, the default 0.0.0.0/0 is used as a destination route."
  type        = string
  default     = "0.0.0.0/0"
}

variable "network_interface_ids" {
  description = "A list of network interface IDs. Fist element will be to the first AZ, second, to the second, ..."
  type        = list(string)
  default     = []
}
