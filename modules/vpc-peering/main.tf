locals {
  # start edit #
  # enabled = module.this.enabled
  enabled = var.enabled
  #  end edit  #
  count = local.enabled ? 1 : 0

  accepter_enabled = local.enabled && var.accepter_enabled
  accepter_count   = local.enabled && var.accepter_enabled ? 1 : 0
}
