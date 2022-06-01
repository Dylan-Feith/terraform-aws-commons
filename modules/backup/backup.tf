resource "aws_backup_region_settings" "settings" {
  resource_type_opt_in_preference     = merge(var.backup_region_resource_type_opt_in_preference, var.backup_region_resource_type_opt_in_preference_override)
  resource_type_management_preference = merge(var.backup_region_resource_type_management_preference, var.backup_region_resource_type_management_preference_override)
}
