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
