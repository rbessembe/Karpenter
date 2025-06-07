variable "cluster_name" {
  type    = string
  default = ""
}

variable "cluster_endpoint" {
  type    = string
  default = "" # starting with https://
}

variable "cluster_oidc_provider_arn" {
  type    = string
  default = ""
}

variable "vpc_subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "karpenter_instance_profile_name" {
  type    = string
  default = "karpenter"
}
