data "template_file" "helm_values_gitlab" {
  template = file("./templates/gitlab-values.yaml.tpl")

  vars = {
    DOMAIN      = var.gitlab_domain
  }
}

resource "helm_release" "gitlab" {
  name       = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"

  values = [data.template_file.helm_values_gitlab.rendered]
}

resource "helm_release" "k3s_ingress_gitlab" {
  name  = "k3s-ingress-gitlab"
  chart = "./charts/k3s-ingress-gitlab"

  values = [
    file("./charts/k3s-ingress-gitlab/values.yaml")
  ]

  set {
    name  = "domain"
    value = var.gitlab_domain
    type  = "string"
  }
}
