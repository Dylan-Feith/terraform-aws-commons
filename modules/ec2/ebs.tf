data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}
resource "aws_ebs_volume" "this" {
  for_each          = var.additionnal_ebs_block_device
  availability_zone = try(aws_instance.this[0].availability_zone, "")
  size              = each.value.size
  iops              = try(each.value.iops, null)
  throughput        = try(each.value.throughput, null)
  type              = try(each.value.type, null)
  encrypted         = try(each.value.encrypted, true)
  kms_key_id        = try(each.value.encrypted, true) ? try(each.value.kms_key_id, data.aws_kms_key.ebs.arn) : null
  tags = merge(
    try(each.value.tags, {}),
    {
      Name = format("%s-%s-%s", var.name, each.key, each.value.size)
    }
  )
}
resource "aws_volume_attachment" "this" {
  for_each    = var.additionnal_ebs_block_device
  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.this[each.key].id
  instance_id = try(aws_instance.this[0].id, "")
}
