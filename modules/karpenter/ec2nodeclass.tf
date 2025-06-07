resource "kubectl_manifest" "karpenter_ec2_nodeclass" {
  depends_on = [helm_release.karpenter]
  yaml_body  = <<YAML
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: Bottlerocket
  amiSelectorTerms:
    - id: "ami-example"  
  subnetSelectorTerms:
    - id: "subnet-example"
  securityGroupSelectorTerms:
    - id: "sg-example"
  instanceProfile: ${var.karpenter_instance_profile_name}
YAML
}
