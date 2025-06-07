data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_ecrpublic_authorization_token" "karpenter" {}
