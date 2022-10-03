variable "aws_profile" {
  description = "AWS profile to access AWS API"
}

variable "remote_state_bucket_region" {
  description = "AWS region the backend s3 bucket is created in"
  default     = "eu-west-2"
}

variable "remote_state_s3_bucket" {
  description = "AWS S3 bucket in which to store main application terraform state"
  default     = "gitlab-kubernetes-with-ci-tf-state"
}

variable "remote_state_lock_table" {
  description = "AWS DynamoDB terraform state lock table name"
  default     = "gitlab-kubernetes-with-ci-tf-state-lock-table"
}
