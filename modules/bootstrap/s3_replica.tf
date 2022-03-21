resource "aws_s3_bucket_replication_configuration" "replication" {
  provider   = aws.main_region
  depends_on = [aws_s3_bucket_versioning.main]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.main.id

  rule {
    id       = "replication"
    priority = 0
    status   = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_s3_bucket" "replica" {
  provider = aws.secondary_region
  bucket   = substr(format("%s-%s-%s-tf-states-critical-replica", var.customer, var.project, var.globalenv), 0, 63)

  lifecycle {
    ignore_changes = [
      lifecycle_rule
    ]
  }
  tags = {
    Name      = substr(format("%s-%s-%s-tf-states-critical-replica", var.customer, var.project, var.globalenv), 0, 63)
    customer  = var.customer
    project   = var.project
    globalenv = var.globalenv
    tfrun     = "bootstrap"
  }
}

resource "aws_s3_bucket_public_access_block" "replica" {
  provider                = aws.secondary_region
  bucket                  = aws_s3_bucket.replica.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "replica" {
  provider = aws.secondary_region
  bucket   = aws_s3_bucket.replica.id
  acl      = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  provider = aws.secondary_region
  bucket   = aws_s3_bucket.replica.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.secondary_region
  bucket   = aws_s3_bucket.replica.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "replica" {
  provider = aws.secondary_region
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.replica]

  bucket = aws_s3_bucket.replica.bucket

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
