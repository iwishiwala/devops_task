variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use (optional)"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "takehome-eks"
}

variable "environment_name" {
  description = "Environment name"
  type        = string
  default     = "takehome"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of AZs to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "domain_name" {
  description = "Domain name for HTTPS certificate (optional)"
  type        = string
  default     = ""
}
