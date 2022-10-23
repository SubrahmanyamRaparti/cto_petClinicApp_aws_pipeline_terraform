# ------------------------------------------------------------------------------
# Code Pipeline S3 Management
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "cto_artifact_bucket" {
  bucket = "${local.prefix}-codepipeline"
  # force_destroy = true
  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.cto_artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cto_artifact_bucket_encryption" {
  bucket = aws_s3_bucket.cto_artifact_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}