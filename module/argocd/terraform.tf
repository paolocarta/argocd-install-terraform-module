terraform {
  required_version = ">= 1.10.0"

  required_providers {
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "~> 2.35.1"
    # }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
  }
}