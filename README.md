# GitLab Kubernetes with CI

Sample scripts and AWS infrastructure to setup GitLab instance and example CI improvements outlined in my blog post: <add here>

## Setup

### Dependencies

Required CLI tools on your local machine:
- [aws-cli v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [bash](https://www.gnu.org/software/bash/) ([command-not-found](https://command-not-found.com/bash))
- [terraform v1.2.9](https://learn.hashicorp.com/tutorials/terraform/install-cli) ([tfenv](https://github.com/tfutils/tfenv) can be useful)


### AWS Credentials

Create an AWS IAM user with the relevant permissions for the Terraform setup e.g. AWS S3, or use `AdministratorAccess` for quicker setup.

Add the access keys for the IAM user to the `gitlab-kubernetes-with-ci` AWS profile in the credentials list on your machine:

```sh
sudo vim ~/.aws/credentials
```

```
[gitlab-kubernetes-with-ci]
aws_access_key_id = <iam user access key id>
aws_secret_access_key = <iam user secret key>
```

### Kubernetes Cluster

The GitLab application in this repository is configured to deploy to a Kubernetes using helm. Please ensure you have a Kubernetes cluster created with at least 2 nodes and the configuration file located on your local machine at `~/.kube/config`. 

The application will deploy to the `gitlab` namespace in the default cluster.

The infrastructure is set up to work with a (my) local install of [k3s](https://k3s.io/), please adjust to match your cluster if required.

The GitLab chart variables can be found in [`terraform/infrastructure/templates/gitlab-values.yaml.tpl`](./terraform/infrastructure/templates/gitlab-values.yaml.tpl) with basic config in [`terraform/infrastructure.env`](./terraform/infrastructure.env).


### Clone Repository

Clone the project to your local machine and navigate to the project root directory.

### Create the Infrastructure Environment Variables

Create `infrastructure.env` in the root directory from the [`infrastructure.env.example`](./infrastructure.env.template) template.

Ignore the `TF_VAR_gitlab_runner_registration_token` variable for now, since it won't be available until after GitLab is deployed.

### Create the Infrastructure

Create the infrastructure:

```sh
./scripts/build_infrastructure
```

### Add Public SSH Key to GitLab User

The GitLab UI is configured to use the k3s traefik ingress located [here](./terraform/infrastructure/charts/k3s-ingress-gitlab/). The ingress will point to your domain defined in [`./terraform/infrastructure.env`](./terraform/infrastructure.env), by default this is `gitlab.gitlab.cpcwood`.

If your cluster is not public, you may need to add your custom domain to your hosts file to be able to connect., e.g.

```
# /etc/hosts
# ...

<cluster-ip> gitlab.gitlab.cpcwood
```

Get auto generated GitLab root user password from secret: ```kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo```

Login to the GitLab UI using the admin credentials:

```txt
username: root
password: <password>
```

Add your public SSH key to your user.


### Push Sample Repository

TODO

### Create GitLab Runner

Get a runner registration token from the GitLab Runners admin page: `https://gitlab.example/admin/runners` by clicking the register runner button.

Add the token to the `TF_VAR_gitlab_runner_registration_token` variable in your `infrastructure.env`.

Re-deploy the application using `./scripts/apply_infrastructure`.

Note: The runner registration token is private and should be kept in a Kubernetes secret in production deployments.

---

## Notes

- This deployment of GitLab is for demonstration and is not intended to be production ready.
