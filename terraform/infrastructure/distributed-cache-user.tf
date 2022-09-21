resource "aws_iam_user" "gitlab_runner_distributed_cache_access" {
  name = "gitlab-runner-distributed-cache-access"
}

resource "aws_iam_access_key" "gitlab_runner_distributed_cache_access" {
  user = aws_iam_user.gitlab_runner_distributed_cache_access.name
}

data "aws_iam_policy_document" "gitlab_runner_distributed_cache_access" {
  statement {
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.gitlab_runner_distributed_cache.arn}/*"
    ]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]
  }
}

resource "aws_iam_policy" "gitlab_runner_distributed_cache_access" {
  name   = "gitlab-runner-distributed-cache-access"
  policy = data.aws_iam_policy_document.gitlab_runner_distributed_cache_access.json
}

resource "aws_iam_user_policy_attachment" "gitlab_runner_distributed_cache_access" {
  user       = aws_iam_user.gitlab_runner_distributed_cache_access.name
  policy_arn = aws_iam_policy.gitlab_runner_distributed_cache_access.arn
}
