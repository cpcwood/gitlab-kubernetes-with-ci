# GitLab Kubernetes with CI

Scripts and infrastructure to setup example GitLab instance to demonstrate the CI improvements outlined in my blog post: [How We Reduced Our GitLab CI Pipeline Duration by 70% at Student Beans](https://www.cpcwood.com/blog/6-how-we-reduced-our-gitlab-ci-pipeline-duration-by-70-at-student-beans).

## Setup

### Dependencies

Required CLI tools on your local machine:
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

The GitLab application in this repository is configured to deploy to a Kubernetes using [Helm](https://helm.sh/). Please ensure you have a Kubernetes cluster created with at least 2 nodes and the configuration file located on your local machine at `~/.kube/config`. 

The application will deploy to the `gitlab` namespace in the default cluster.

The infrastructure is set up to work with a local install of [k3s](https://k3s.io/), please adjust to match your cluster if required.

The GitLab helm chart variables can be found in [`terraform/infrastructure/templates/gitlab-values.yaml.tpl`](./terraform/infrastructure/templates/gitlab-values.yaml.tpl) with basic config in [`terraform/.env`](./terraform/.env).


### Clone Repository

Clone the project to your local machine and navigate to the project root directory.

### Create the Infrastructure Environment Variables

Create `.env` in the root directory from the [`.env.example`](./.env.template) template.

Ignore the `TF_VAR_gitlab_runner_registration_token` variable for now, since it won't be available until after GitLab is deployed.

### Create the Infrastructure

Create the infrastructure:

```sh
./scripts/build-infrastructure
```

### Add Public SSH Key to GitLab User

The GitLab UI is configured to use the k3s traefik ingress located [here](./terraform/infrastructure/charts/k3s-ingress-gitlab/). The ingress will point to your domain defined in [`./terraform/.env`](./terraform/.env), the domain value is set in the [`.env`](./.env) file `TF_VAR_gitlab_domain` variable and has a default value of `gitlab.gitlab.example`.

If your cluster is not public, you may need to add your custom domain to your hosts file to be able to connect., e.g.

```
# /etc/hosts
# ...

<cluster-ip> gitlab.gitlab.example
```

Get auto generated GitLab root user password from secret: ```kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo```

Login to the GitLab UI using the admin credentials:

```txt
username: root
password: <password>
```

Add your public SSH key to your GitHub user.


### Create GitLab Runner

#### Add Registration Token

Get a runner registration token from the GitLab Runners admin page: [https://gitlab.gitlab.example/admin/runners](https://gitlab.gitlab.example/admin/runners) by clicking the register runner button.

Add the token to the `TF_VAR_gitlab_runner_registration_token` variable in your `.env`.

#### Add Container Registry Credentials to .env

Create an access token to your container registry

Add your container registry username and token to the `.env` file in `TF_VAR_container_registry_user` and `TF_VAR_container_registry_token` respectively, these will be added to the GitLab Runner environment.

Notes:
- The runner config is configured to use DockerHub in the docker auth, if you use something else (AWS ECR) please edit the auth config `DOCKER_AUTH` in [terraform/infrastructure/templates/gitlab-runner-values.yaml.tpl](./terraform/infrastructure/templates/gitlab-runner-values.yaml.tpl).

#### Deploy Runner

Re-deploy the application using `./scripts/apply-infrastructure`.


### Add Sample Project

#### Setup Container Repository

Create the following container repositories for the sample project in DockerHub or other registry.

- `<registry-user>/sample-project`
- `<registry-user>/sample-project-cache`


#### Push to GitLab

Push sample project to your GitLab instance:

```sh
./scripts/push-sample-project
```

#### Run Pipeline

Trigger a GitLab CI pipeline in the [sample repository](https://gitlab.gitlab.example/root/sample-project) on the `main` branch to test the runner configuration.


## Teardown

To destroy all infrastructure and remote state, run the teardown script:

```sh
./scripts/destroy-infrastructure
```

Other things to remove:
- Remove or disable any authentication tokens you created for the container registry.
- Remove `gitlab.gitlab.example` entries from `/etc/hosts`
- 

## Notes

- This deployment of GitLab is for demonstration and is not intended to be production ready.
