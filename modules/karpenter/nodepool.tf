resource "kubectl_manifest" "karpenter_nodepool" {
  depends_on = [helm_release.karpenter]
  yaml_body  = <<YAML
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      nodeClassRef:
        name: default
        kind: EC2NodeClass
        group: karpenter.k8s.aws
      requirements:
        - key: "node.kubernetes.io/instance-type"
          operator: In
          values: ["t3.medium", "t3.xlarge"]
  limits:
    cpu: 200
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 300s
    expireAfter: 720h
YAML
}
