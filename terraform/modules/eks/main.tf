module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 19.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version
  subnet_ids         = var.private_subnets
  vpc_id             = var.vpc_id

  eks_managed_node_groups = {
    default_nodes = {
      desired_size = var.node_group_desired_capacity
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size

      instance_types = var.instance_types

      # Additional configuration for stability
      disk_size = 20

      # Ensure nodes can be replaced if they fail
      update_config = {
        max_unavailable_percentage = 25
      }

      # Add labels for better management
      labels = {
        Environment = "takehome"
        NodeGroup   = "default"
      }
    }
  }

  tags = var.tags
}
