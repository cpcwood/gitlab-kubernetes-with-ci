gitlabUrl: ${DOMAIN}
runnerRegistrationToken: ${REGISTRATION_TOKEN}
rbac:
  create: true
runners:
  config: |
    [[runners]]
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
