resource "aws_cloudwatch_metric_alarm" "ec2_disk" {
  count               = var.create && !var.create_spot_instance && var.cw_disk_used_percent_alarms ? 1 : 0
  alarm_name          = "${var.name}-alarm-disk"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  treat_missing_data  = var.cw_disk_used_percent_treat_missing_data
  threshold           = var.cw_disk_used_percent_threshold
  alarm_description   = "EC2 DU Alarm for ${var.name}"
  alarm_actions       = var.cw_disk_used_percent_alarm
  ok_actions          = var.cw_disk_used_percent_ok
  tags                = var.tags
  dimensions = {
    InstanceId = try(aws_instance.this[0].id, "")
  }
}
