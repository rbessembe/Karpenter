provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = "karpenter"
  create_namespace = true

  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.karpenter.user_name
  repository_password = data.aws_ecrpublic_authorization_token.karpenter.password

  chart   = "karpenter"
  version = "1.5.0"

  values = [
    templatefile("${path.module}/policies/karpenter-values.yaml.tmpl", {
      cluster_name                    = var.cluster_name
      cluster_endpoint                = var.cluster_endpoint
      karpenter_instance_profile_name = var.karpenter_instance_profile_name
    })
  ]

  depends_on = [kubernetes_service_account.karpenter]

}


