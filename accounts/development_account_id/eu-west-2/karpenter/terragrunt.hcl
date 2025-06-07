terraform {
  source = "../../../modules/karpenter"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name                   = "dev-eks-cluster"
  cluster_endpoint               = "https://ABCDEF.gr7.eu-west-2.eks.amazonaws.com"
  cluster_oidc_provider_arn     = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/XYZ"

  vpc_subnet_ids = [
    "subnet-example-1",
    "subnet-example-2"
  ]

  security_group_ids = [
    "sg-example-1",
    "sg-example-2"
  ]

  karpenter_instance_profile_name = "KarpenterInstanceProfile"
}
