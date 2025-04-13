variable "namespace" {
  type        = string
  description = "Kubernetes namespace to install Argo CD."
  default     = "argocd"
}

variable "chart_version" {
  type        = string
  description = "Version of the Argo CD Helm chart."
  default     = "7.8.23" # https://artifacthub.io/packages/helm/argo/argo-cd
}

variable "root_app_of_apps" {
  type = object({
    repo_url = string
    branch = optional(string, "main")
    manifest_path = optional(string, "bootstrap")
    project_name = optional(string, "default")
    recurse = optional(bool, false)
  })
  description = "Git repo and path to the ArgoCD Applications"
}

variable "kubernetes" {
  type = object({
    cluster_endpoint                   = string
    cluster_certificate_authority_data = string
    cluster_name                       = string
  })
  description = "Cluster endpoint and credentials"
}

variable "hostname" {
  type = string
  description = "Hostname to expose argocd using ingress"
}

variable "ingress_class_name" {
  type = string
  default = "traefik"
  description = "Ingress class name to expose argocd using ingress"
}

variable "node_label" {
  type = string
  description = "Node label for nodeSelector"
}


# --- Variables not used in this plan ---

# variable "service_account" {
#   type = string
#   default = "argocd-repo-server"
#   description = "IRSA service account"
# }

# variable "iam_policy_name" {
#   type = string
#   default = "argocd"
#   description = "IAM policy name for argocd"
# }


