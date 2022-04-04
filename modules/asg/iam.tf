data "aws_iam_policy_document" "this" {
  statement {
    sid = "ForEc2"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "this" {
  count                = local.create ? 1 : 0
  name                 = var.name
  path                 = "/ec2/"
  assume_role_policy   = data.aws_iam_policy_document.this.json
  permissions_boundary = var.permissions_boundary_arn
  tags                 = merge({ "Name" = var.name }, var.tags)
}

resource "aws_iam_instance_profile" "this" {
  count = local.create ? 1 : 0
  name  = var.name
  role  = try(aws_iam_role.this[0].name, "")
  tags  = merge({ "Name" = var.name }, var.tags)
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = local.create ? length(var.policies_arn) : 0
  role       = try(aws_iam_role.this[0].name, "")
  policy_arn = element(var.policies_arn, count.index)
}
