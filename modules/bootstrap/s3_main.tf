resource "aws_s3_bucket" "main" {
  provider = aws.main_region
  bucket   = substr(format("%s-%s-%s-tf-states-critical", var.customer, var.project, var.globalenv), 0, 63)

  lifecycle {
    ignore_changes = [
      lifecycle_rule
    ]
  }
  tags = {
    Name      = substr(format("%s-%s-%s-tf-states-critical", var.customer, var.project, var.globalenv), 0, 63)
    customer  = var.customer
    project   = var.project
    globalenv = var.globalenv
    tfrun     = "bootstrap"
  }
}

resource "aws_s3_bucket_acl" "main" {
  provider = aws.main_region
  bucket   = aws_s3_bucket.main.id
  acl      = "private"
}

resource "aws_s3_bucket_public_access_block" "main" {
  provider                = aws.main_region
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "main" {
  provider = aws.main_region
  bucket   = aws_s3_bucket.main.id
  policy   = data.aws_iam_policy_document.prevent_unencrypted_uploads.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  provider = aws.main_region
  bucket   = aws_s3_bucket.main.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "main" {
  provider = aws.main_region
  bucket   = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
    #    mfa_delete = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.main]

  bucket = aws_s3_bucket.main.bucket

  rule {
    id = "config"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}
