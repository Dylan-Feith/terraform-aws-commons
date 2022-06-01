locals {
  #### start edit ####
  enabled = var.enabled
  ####  end edit  ####
  plan_enabled     = local.enabled && var.plan_enabled
  iam_role_enabled = local.enabled && var.iam_role_enabled
  iam_role_name    = coalesce(var.iam_role_name, var.name)
  vault_enabled    = local.enabled && var.vault_enabled
  vault_name       = coalesce(var.vault_name, var.name)
  vault_id         = join("", local.vault_enabled ? aws_backup_vault.default.*.id : data.aws_backup_vault.existing.*.id)
  vault_arn        = join("", local.vault_enabled ? aws_backup_vault.default.*.arn : data.aws_backup_vault.existing.*.arn)
}

data "aws_partition" "current" {}

#### start edit ####
data "aws_kms_key" "backup" {
  key_id = "alias/aws/backup"
}
####  end edit  ####

resource "aws_backup_vault" "default" {
  count = local.vault_enabled ? 1 : 0
  name  = local.vault_name
  #### start edit ####
  kms_key_arn = var.kms_key_arn == null ? data.aws_kms_key.backup.arn : var.kms_key_arn
  tags        = var.tags
  ####  end edit  ####
}

data "aws_backup_vault" "existing" {
  count = local.enabled && var.vault_enabled == false ? 1 : 0
  name  = local.vault_name
}

resource "aws_backup_plan" "default" {
  count = local.plan_enabled ? 1 : 0
  #### start edit ####
  name = var.plan_name_suffix == null ? var.name : format("%s_%s", var.name, var.plan_name_suffix)
  ####  end edit  ####

  rule {
    #### start edit ####
    rule_name = var.name
    ####  end edit  ####
    target_vault_name = join("", local.vault_enabled ? aws_backup_vault.default.*.name : data.aws_backup_vault.existing.*.name)
    schedule          = var.schedule
    start_window      = var.start_window
    completion_window = var.completion_window
    #### start edit ####
    recovery_point_tags = var.tags
    ####  end edit  ####
    enable_continuous_backup = var.enable_continuous_backup

    dynamic "lifecycle" {
      for_each = var.cold_storage_after != null || var.delete_after != null ? ["true"] : []
      content {
        cold_storage_after = var.cold_storage_after
        delete_after       = var.delete_after
      }
    }

    dynamic "copy_action" {
      for_each = var.destination_vault_arn != null ? ["true"] : []
      content {
        destination_vault_arn = var.destination_vault_arn

        dynamic "lifecycle" {
          for_each = var.copy_action_cold_storage_after != null || var.copy_action_delete_after != null ? ["true"] : []
          content {
            cold_storage_after = var.copy_action_cold_storage_after
            delete_after       = var.copy_action_delete_after
          }
        }
      }
    }
  }

  #### start edit ####
  tags = var.tags
  ####  end edit  ####
}

data "aws_iam_policy_document" "assume_role" {
  count = local.iam_role_enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  count              = local.iam_role_enabled ? 1 : 0
  name               = local.iam_role_name
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  #### start edit ####
  tags = var.tags
  ####  end edit  ####
}

data "aws_iam_role" "existing" {
  count = local.enabled && var.iam_role_enabled == false ? 1 : 0
  name  = local.iam_role_name
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = local.iam_role_enabled ? 1 : 0
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_backup_selection" "default" {
  count = local.plan_enabled ? 1 : 0
  #### start edit ####
  name = var.name
  ####  end edit  ####
  iam_role_arn  = join("", var.iam_role_enabled ? aws_iam_role.default.*.arn : data.aws_iam_role.existing.*.arn)
  plan_id       = join("", aws_backup_plan.default.*.id)
  resources     = var.backup_resources
  not_resources = var.not_resources
  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }
}
