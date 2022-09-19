global:
  ingress:
    configureCertmanager: false
    enabled: false
  hosts:
    domain: ${DOMAIN}
  shell:
    port: 32022
  webservice:
    replicaCount: 1

certmanager:
  install: false

nginx-ingress:
  enabled: false

gitlab-runner:
  install: false
  
gitlab:
  gitaly:
    persistence:
      storageClass: local-path
      size: 5Gi
  gitlab-shell:
    service:
      type: NodePort
      nodePort: 32022
  sidekiq:
    concurrency: 3
  metrics:
    enabled: false


postgresql:
  persistence:
    storageClass: local-path
    size: 5Gi
  metrics:
    enabled: true

redis:
  master:
    persistence:
      storageClass: local-path
      size: 2Gi
  metrics:
    enabled: false

minio:
  persistence:
    storageClass: local-path
    size: 2Gi
  metrics:
    enabled: false
    
prometheus:
  install: false