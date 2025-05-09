
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      name = "argocd"
    }
  }
}

resource "helm_release" "argocd" {

  max_history = 5
  name        = "argo-cd"
  chart       = "argo-cd"
  repository  = "https://argoproj.github.io/argo-helm"
  namespace   = kubernetes_namespace.argocd.id
  version     = var.chart_version                                # https://artifacthub.io/packages/helm/argo/argo-cd
  
  values      = [
    templatefile("${path.module}/manifests/argocd-values.tmpl.yaml", {
      hostname = var.hostname,
      ingress_class_name = var.ingress_class_name,
      node_label = var.node_label,
      git_url = "git@gitlab.mycompany.com"
      git_repo_url = var.application_source.repoURL
      secret_argocd_admin_password = "<my-secret>"
      gitlab_ssh_private_key = "<my-ssh-key>"
    })
  ]

  timeout    = 600
  wait       = true   # This is the default
}


resource "kubernetes_manifest" "app_of_apps" {
  depends_on = [helm_release.argocd]

  manifest = yamldecode(
    templatefile("${path.module}/manifests/app-of-apps.tmpl.yaml", {
      repo_url       = var.root_app_of_apps.repo_url
      branch         = var.root_app_of_apps.branch
      manifest_path  = var.root_app_of_apps.manifest_path
      project_name   = var.root_app_of_apps.project_name
      recurse        = var.root_app_of_apps.recurse  
    })
  )
}


# resource "kubernetes_manifest" "test" {
#   # Make sure we wait until Argo CD is fully installed (and CRDs exist)
#   depends_on = [helm_release.argocd]

#   manifest = yamldecode(data.http.app_of_apps_yaml.body) )
# }

# data "http" "app_of_apps_yaml" {
#   url = "https://raw.githubusercontent.com/other-org/other-repo/main/path/to/app-of-apps.yaml"
# }