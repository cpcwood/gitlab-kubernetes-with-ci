gitlabUrl: ${DOMAIN}
runnerRegistrationToken: ${REGISTRATION_TOKEN}
rbac:
  create: true
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        image = "alpine:latest"
