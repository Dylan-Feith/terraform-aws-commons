data "aws_default_tags" "current" {}
locals {
  default_tags = data.aws_default_tags.current.tags
}
