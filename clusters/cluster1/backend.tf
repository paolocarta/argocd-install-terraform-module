terraform {
    backend "s3" {
        bucket          = "interview-prep-paolos-terraform-remote-state"
        key             = "envs/test/k8s-clusters.tfstate"
        region          = "ap-southeast-1"
        encrypt         = true
        dynamodb_table  = "interview-prep-paolos-terraform-remote-state-lock"
    }
}