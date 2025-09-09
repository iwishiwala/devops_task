variable "cluster_oidc_issuer_url" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}

variable "role_name_prefix" {
  description = "Prefix for IAM role name"
  type        = string
  default     = "alb-controller"
}

variable "namespace_service_accounts" {
  description = "Namespace and service account pairs for IRSA"
  type        = list(string)
  default     = ["kube-system:aws-load-balancer-controller"]
}
