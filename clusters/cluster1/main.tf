module "argocd" {
  source = "../../modules/argocd"

  name     = "cluster1"
  hostname = "argocd.cluster1.my-company.com"

  kubernetes = {
    cluster_endpoint                   = module.aws_eks.cluster_endpoint
    cluster_certificate_authority_data = module.aws_eks.cluster_certificate_authority_data
    cluster_name                       = module.aws_eks.cluster_name
    cluster_oidc_issuer_url            = module.aws_eks.cluster_oidc_issuer_url
  }

  node_label = "system"

  application_source = {
    repoURL = "git@gitlab.my-company-com:infra/gitops-repo"
    path    = "argocd/bootstrap/root-app-dev.yaml"
  }
}