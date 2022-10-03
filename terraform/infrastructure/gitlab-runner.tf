data "template_file" "helm_values_gitlab_runner" {
  count    = var.gitlab_runner_registration_token != "" ? 1 : 0
  template = file("./templates/gitlab-runner-values.yaml.tpl")

  vars = {
    GITLAB_SERVICE_URL                = "http://gitlab-webservice-default.default.svc.cluster.local:8181"
    GITLAB_DOMAIN                     = "gitlab.${var.gitlab_domain}"
    CLUSTER_IP                        = var.kubernetes_cluster_ip
    REGISTRATION_TOKEN                = var.gitlab_runner_registration_token
    CONTAINER_REGISTRY_USER           = var.container_registry_user
    CONTAINER_REGISTRY_AUTH           = base64encode("${var.container_registry_user}:${var.container_registry_token}")
    DISTRIBUTED_CACHE_BUCKET_NAME     = aws_s3_bucket.gitlab_runner_distributed_cache.id
    DISTRIBUTED_CACHE_BUCKET_LOCATION = aws_s3_bucket.gitlab_runner_distributed_cache.region
    DISTRIBUTED_CACHE_AWS_ACCESS_KEY  = aws_iam_access_key.gitlab_runner_distributed_cache_access.id
    DISTRIBUTED_CACHE_AWS_SECRET_KEY  = aws_iam_access_key.gitlab_runner_distributed_cache_access.secret
  }
}

resource "helm_release" "gitlab_runner" {
  count      = var.gitlab_runner_registration_token != "" ? 1 : 0
  name       = "gitlab-runner"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab-runner"
  version    = "0.44.0"

  values = [data.template_file.helm_values_gitlab_runner[0].rendered]
}
