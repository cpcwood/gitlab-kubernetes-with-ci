data "template_file" "helm_values_gitlab_runner" {
  count    = var.gitlab_runner_registration_token != "" ? 1 : 0
  template = file("./templates/gitlab-runner-values.yaml.tpl")

  vars = {
    DOMAIN             = "http://gitlab-webservice-default.default.svc.cluster.local:8080"
    REGISTRATION_TOKEN = var.gitlab_runner_registration_token
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
