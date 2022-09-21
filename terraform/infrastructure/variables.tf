variable "aws_profile" {
  description = "AWS profile to access AWS API"
}

variable "application_aws_region" {
  description = "AWS region to build infrastructure in"
  default     = "eu-west-2"
}

variable "gitlab_domain" {
  description = "GitLab instance domain name"
}

variable "gitlab_runner_registration_token" {
  description = "GitLab runner registration token from the admin console (leave blank if not available)"
}

variable "gitlab_runner_distributed_cache_bucket" {
  description = "Name of AWS S3 bucket to create for gitlab runner distributed cache"
}

variable "distributed_cache_object_expiration_days" {
  type        = number
  default     = 90
  description = "Number of days after which distributed cache objects are deleted"
}