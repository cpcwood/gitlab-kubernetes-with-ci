resource "random_id" "gitlab_runner_distributed_cache" {
  byte_length = 6
}

resource "aws_s3_bucket" "gitlab_runner_distributed_cache" {
  bucket        = "${var.gitlab_runner_distributed_cache_bucket}-${random_id.gitlab_runner_distributed_cache.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.gitlab_runner_distributed_cache.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "bucket_policy" {
  bucket = aws_s3_bucket.gitlab_runner_distributed_cache.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_config" {
  bucket = aws_s3_bucket.gitlab_runner_distributed_cache.id

  rule {
    id     = "expire-cache"
    status = "Enabled"
    expiration {
      days = var.distributed_cache_object_expiration_days
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_policy" {
  bucket = aws_s3_bucket.gitlab_runner_distributed_cache.id

  versioning_configuration {
    status = "Disabled"
  }
}
