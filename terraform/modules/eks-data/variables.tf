variable "cluster_id" {
  description = "EKS cluster ID"
  type        = string
}

variable "eks_dependency" {
  description = "EKS module dependency"
  type        = any
  default     = null
}
