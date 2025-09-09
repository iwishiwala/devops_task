variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

variable "private_subnets" {
  description = "Private subnets for EKS"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for EKS"
  type        = string
}

variable "node_group_desired_capacity" {
  description = "Desired size for EKS node group"
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "Minimum size for EKS node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size for EKS node group"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {}
}
