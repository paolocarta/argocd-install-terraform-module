

data "aws_eks_cluster" "main" {
  name = "paolos-test-eks-cluster-1"
  # name = data.terraform_remote_state.eks.outputs.cluster_name

}

data "aws_eks_cluster_auth" "main" {
  name = "paolos-test-eks-cluster-1"
}

