terraform {
  required_version = "1.2.9"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6"
    }
    aws = {
      version = "~> 4.31"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

  experiments {
    manifest = true
  }
}

provider "aws" {
  region  = var.application_aws_region
  profile = var.aws_profile
}

