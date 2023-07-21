terraform {
  required_version = "~> 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "bizkt"
    workspaces {
      name = "blog-infra-edge-functions"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
