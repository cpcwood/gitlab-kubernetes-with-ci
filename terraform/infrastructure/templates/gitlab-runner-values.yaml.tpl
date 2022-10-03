gitlabUrl: ${GITLAB_SERVICE_URL}
runnerRegistrationToken: ${REGISTRATION_TOKEN}
rbac:
  create: true
runners:
  config: |
    [[runners]]
      pre_clone_script = "echo '${CLUSTER_IP} ${GITLAB_DOMAIN}' >> /etc/hosts"
      environment = [ 
        'GIT_SSL_NO_VERIFY=true',
        'CONTAINER_REGISTRY_USER=${CONTAINER_REGISTRY_USER}',
        'DOCKER_AUTH={"auths":{"https://index.docker.io/v1/":{"auth":"${CONTAINER_REGISTRY_AUTH}"}}}'
      ]
      
      [runners.kubernetes]
        image = "alpine:latest"
      
      [runners.cache]
        Type = "s3"
        Path = "runner-cache"
        Shared = true
        [runners.cache.s3]
          ServerAddress = "s3.amazonaws.com"
          BucketName = "${DISTRIBUTED_CACHE_BUCKET_NAME}"
          BucketLocation = "${DISTRIBUTED_CACHE_BUCKET_LOCATION}"
          AccessKey = "${DISTRIBUTED_CACHE_AWS_ACCESS_KEY}"
          SecretKey = "${DISTRIBUTED_CACHE_AWS_SECRET_KEY}"
