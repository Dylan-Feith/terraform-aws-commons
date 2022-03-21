##########################
# Replication between s3 #
##########################

resource "aws_iam_role" "replication" {
  name               = format("%s-%s-%s-tf-states-replication", var.customer, var.project, var.globalenv)
  assume_role_policy = data.aws_iam_policy_document.replication_sts.json
  tags = {
    Name      = format("%s-%s-%s-tf-states-replication", var.customer, var.project, var.globalenv)
    customer  = var.customer
    project   = var.project
    globalenv = var.globalenv
    tfrun     = "bootstrap"
  }
}

data "aws_iam_policy_document" "replication_sts" {
  statement {
    sid     = "AllowPrimaryToAssumeServiceRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "replication" {
  name   = format("%s-%s-%s-tf-states-replication", var.customer, var.project, var.globalenv)
  policy = data.aws_iam_policy_document.replication.json
  tags = {
    Name      = format("%s-%s-%s-tf-states-replication", var.customer, var.project, var.globalenv)
    customer  = var.customer
    project   = var.project
    globalenv = var.globalenv
    tfrun     = "bootstrap"
  }
}

data "aws_iam_policy_document" "replication" {
  statement {
    sid    = "AllowPrimaryToGetReplicationConfiguration"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:ListBucket"
    ]
    resources = [
      join("", aws_s3_bucket.main.*.arn),
      "${join("", aws_s3_bucket.main.*.arn)}/*"
    ]
  }
  statement {
    sid    = "AllowPrimaryToReplicate"
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "${join("", aws_s3_bucket.replica.*.arn)}/*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


#########################
#  force s3 encryption  #
#########################
data "aws_iam_policy_document" "prevent_unencrypted_uploads" {
  statement {
    sid    = "DenyIncorrectEncryptionHeader"
    effect = "Deny"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${join("", aws_s3_bucket.main.*.arn)}/*"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values = [
        "AES256",
        "aws:kms"
      ]
    }
  }

  statement {
    sid    = "DenyUnEncryptedObjectUploads"
    effect = "Deny"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${join("", aws_s3_bucket.main.*.arn)}/*"
    ]
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values = [
        "true"
      ]
    }
  }

  statement {
    sid    = "EnforceTlsRequestsOnly"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      join("", aws_s3_bucket.main.*.arn),
      "${join("", aws_s3_bucket.main.*.arn)}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
