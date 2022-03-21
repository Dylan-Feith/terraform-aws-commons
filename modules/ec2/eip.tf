resource "aws_eip" "this" {
  # We need to set == true because associate_public_ip_address must be null when you configure your own network interface
  count    = var.associate_public_ip_address == true && var.assign_eip_address ? 1 : 0
  instance = try(aws_instance.this[0].id, "")
  vpc      = true
  tags     = merge({ "Name" = var.name }, var.tags)
}
