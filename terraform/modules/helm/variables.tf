variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "repository" {
  description = "Helm repository URL"
  type        = string
  default     = "https://aws.github.io/eks-charts"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "kube-system"
}

variable "cluster_id" {
  description = "EKS cluster ID"
  type        = string
}

variable "service_account_name" {
  description = "Service account name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "irsa_dependency" {
  description = "IRSA module dependency"
  type        = any
  default     = null
}
