data "aws_eks_cluster_auth" "cluster" {
  name = var.kubernetes.cluster_name
}

provider "kubernetes" {
  host                   = var.kubernetes.cluster_endpoint
  cluster_ca_certificate = base64decode(var.kubernetes.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes.cluster_endpoint
    cluster_ca_certificate = base64decode(var.kubernetes.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
