# AWS provider
provider "aws" {
  region = var.aws_region
}

# Kubernetes and Helm providers are configured in main.tf after EKS data sources