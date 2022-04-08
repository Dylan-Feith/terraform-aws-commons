resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "keenobi-${module.label.customer}-${module.label.project}-diskusage"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 15,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "explorer",
            "properties": {
                "metrics": [
                    {
                        "metricName": "disk_used_percent",
                        "resourceType": "AWS::EC2::Instance",
                        "stat": "Average"
                    }
                ],
                "aggregateBy": {
                    "key": "",
                    "func": ""
                },
                "labels": [
                    {
                        "key": "attributes"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "stacked": false,
                    "rowsPerPage": 50,
                    "widgetsPerRow": 3
                },
                "period": 300,
                "splitBy": "attributes",
                "region": "eu-west-3",
                "title": "Disk Usage"
            }
        }
    ]
}
EOF
}

# Allow keenobi-hub to access to this cloudwatch
variable "cloudwatch_cross_account_monitoring_id" {
  default = 115490118264
}
resource "aws_iam_role" "cloudwatch_cross_account_sharing" {
  name               = "CloudWatch-CrossAccountSharingRole"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_cross_account_sharing_assume_role.json
  tags               = module.label.tags
}
data "aws_iam_policy_document" "cloudwatch_cross_account_sharing_assume_role" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.cloudwatch_cross_account_monitoring_id}:root"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_cross_account_sharing_main" {
  role       = aws_iam_role.cloudwatch_cross_account_sharing.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "cloudwatch_cross_account_sharing_custom" {
  role       = aws_iam_role.cloudwatch_cross_account_sharing.name
  policy_arn = aws_iam_policy.ec2_tag.arn
}
resource "aws_iam_policy" "ec2_tag" {
  name        = "${module.label.id}-ec2-tag"
  path        = "/"
  description = "${module.label.id}-ec2-tag"
  policy      = data.aws_iam_policy_document.ec2_tag.json
  tags        = module.label.tags
}

data "aws_iam_policy_document" "ec2_tag" {
  statement {
    actions = [
      "ec2:Get*",
      "ec2:Describe*",
      "ec2:List*",
      "tag:Get*",
    ]
    resources = ["*"]
  }
}

