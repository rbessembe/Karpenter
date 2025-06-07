# 🚀 Karpenter Deployment for EKS (Terraform + Terragrunt)

This repository provides full infrastructure-as-code setup to deploy [Karpenter](https://karpenter.sh) on Amazon EKS using Terraform and Terragrunt.

It includes:
- IAM roles for Karpenter controller and EC2 nodes
- Helm-based Karpenter installation
- EC2NodeClass and NodePool configuration
- Support for both standalone Terraform and Terragrunt live configuration

---

## 📁 Terragrunt Project Structure

```
.
├── modules/
│   └── karpenter/
│       ├── data.tf
│       ├── helm.tf
│       ├── ec2nodeclass.tf
│       ├── nodepool.tf
│       ├── iam.tf
│       ├── variables.tf
│       └── policies/
│           ├── karpenter-controller-policy.json
│           └── karpenter-values.yaml.tmpl
├── accounts/
│   └── production_account_id/
│       └── eu-west-1/
│           └── karpenter/
│               └── terragrunt.hcl
```

---

## ✅ Prerequisites

- Terraform >= 1.3
- Terragrunt >= 0.45
- AWS CLI configured
- Existing EKS cluster
- kubectl access to the cluster (with ~/.kube/config)
- Helm installed

---

## 🧩 Deploying with Terragrunt

1. Go to the environment folder:

```bash
cd accounts/production_account_id/eu-west-1/karpenter
```

2. Make sure `terragrunt.hcl` looks like this:

```hcl
terraform {
  source = "../../../modules/karpenter"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name                   = "my-cluster"
  cluster_endpoint               = "https://ABCDEF.gr7.eu-west-1.eks.amazonaws.com"
  cluster_oidc_provider_arn     = "arn:aws:iam::123456789012:oidc-provider/..."
  vpc_subnet_ids                 = ["subnet-xxxx", "subnet-yyyy"]
  security_group_ids             = ["sg-aaaa", "sg-bbbb"]
  karpenter_instance_profile_name = "KarpenterInstanceProfile"
}
```

3. Apply with Terragrunt:

```bash
terragrunt init
terragrunt apply
```

---

## 🔍 Verifying the Installation

Check Helm release:

```bash
helm list -n karpenter
```

Check Karpenter pods:

```bash
kubectl get pods -n karpenter
```

Check Karpenter CRDs:

```bash
kubectl get nodepools
kubectl get ec2nodeclasses
```

---

## 🧪 Testing Autoscaling

Apply a test deployment to trigger provisioning:

```yaml
# karpenter-test.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 1
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      containers:
        - name: inflate
          image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
          resources:
            requests:
              cpu: "2"
              memory: "4Gi"
```

Apply the test:

```bash
kubectl apply -f test/karpenter-test.yaml
```

Watch nodes scale up:

```bash
kubectl get nodes -w
```

---

## 🧼 Cleanup

```bash
kubectl delete -f test/karpenter-test.yaml
terragrunt destroy         # if using Terragrunt
# or
terraform destroy          # if using Terraform directly
```

---

## 📚 References

- https://karpenter.sh/docs/
- https://registry.terraform.io/providers/hashicorp/aws/latest
- https://terragrunt.gruntwork.io/
