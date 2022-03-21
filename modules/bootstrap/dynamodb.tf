resource "aws_dynamodb_table" "table" {
  provider       = aws.main_region
  name           = format("%s-%s-%s-tf-locks-critical", var.customer, var.project, var.globalenv)
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID" # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = format("%s-%s-%s-tf-locks-critical", var.customer, var.project, var.globalenv)
    customer  = var.customer
    project   = var.project
    globalenv = var.globalenv
    tfrun     = "bootstrap"
  }
}
