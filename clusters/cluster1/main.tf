module "argocd" {
  source = "../../modules/argocd"

  name     = "cluster1"
  hostname = "argocd.cluster1.my-company.com"

  kubernetes = {
    cluster_endpoint                   = module.aws_eks.cluster_endpoint
    cluster_certificate_authority_data = module.aws_eks.cluster_certificate_authority_data
    cluster_name                       = module.aws_eks.cluster_name
  }

  node_label = "system"

  root_app_of_apps = {
    repo_url        = "git@gitlab.my-company-com:infra/gitops-repo"
    manifest_path   = "argocd/applications/cluster1"
    project_name    = "system"
    recurse         = true
  }
}

# Dummy EKS cluster 
module "aws_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name}-al2"
  cluster_version = "1.31"

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["m6i.large"]

      min_size = 2
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2
    }
  }

  tags = local.tags
}
