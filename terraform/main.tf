# VPC
module "vpc" {
  source = "./modules/vpc"

  environment_name = var.environment_name
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets

  tags = local.tags
}

# EKS Cluster + Node Group (COMMENTED OUT - Using ECS Fargate instead)
# module "eks" {
#   source = "./modules/eks"

#   cluster_name    = var.cluster_name
#   cluster_version = "1.28"
#   private_subnets = module.vpc.private_subnets
#   vpc_id          = module.vpc.vpc_id

#   node_group_desired_capacity = var.node_group_desired_capacity
#   node_group_min_size         = var.node_group_min_size
#   node_group_max_size         = var.node_group_max_size
#   instance_types              = var.instance_types

#   tags = {
#     Environment = "takehome"
#     Project     = "devops-takehome"
#   }
# }

# # EKS Cluster Data Sources (needed for kubernetes + helm)
# module "eks_data" {
#   source = "./modules/eks-data"

#   cluster_id     = module.eks.cluster_id
#   eks_dependency = module.eks
# }

# provider "kubernetes" {
#   host                   = module.eks_data.cluster_endpoint
#   token                  = module.eks_data.cluster_auth_token
#   cluster_ca_certificate = base64decode(module.eks_data.cluster_ca_certificate)
# }

# # AWS Load Balancer Controller (ALB Ingress Controller)

# # IAM/IRSA for ALB Controller
# module "iam_irsa" {
#   source = "./modules/iam-irsa"

#   cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
#   oidc_provider_arn       = module.eks.oidc_provider_arn
#   role_name_prefix        = "alb-controller"
# }

# # Deploy ALB Controller via Helm
# module "helm" {
#   source = "./modules/helm"

#   cluster_id      = module.eks.cluster_id
#   aws_region      = var.aws_region
#   vpc_id          = module.vpc.vpc_id
#   irsa_dependency = module.iam_irsa
# }

# ECR Repository for Docker images
module "ecr" {
  source = "./modules/ecr"

  repository_name = "takehome-app"

  # Repository configuration
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true

  # Lifecycle policy configuration
  lifecycle_policy = {
    keep_tagged_images = 10
    untagged_days      = 1
  }

  tags = {
    Environment = "takehome"
    Project     = "devops-takehome"
  }
}

# ECS Fargate Cluster (Free Tier Friendly)
module "ecs" {
  source = "./modules/ecs"

  cluster_name    = var.cluster_name
  aws_region      = var.aws_region
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  # Container configuration
  container_image = "${module.ecr.repository_url}:latest"
  container_port  = 3000
  host_port       = 3000  # Must match container_port for Fargate awsvpc mode

  # Free Tier optimized settings
  cpu    = 256 # 0.25 vCPU - well within 40 GB-hours/month
  memory = 512 # 512 MB - well within 20 GB/month

  # Service configuration
  desired_count = 1

  # Health check configuration
  health_check_path    = "/"
  health_check_matcher = "200"

  # Logging configuration
  log_retention_days = 7

  tags = {
    Environment = "takehome"
    Project     = "devops-takehome"
  }
}

# IAM/IRSA for GitHub Actions
module "github_oidc" {
  source = "./modules/github_oidc"

  role_name     = "github-actions"
  github_repo   = "org/repo"
  github_branch = "main"

  tags = {
    Environment = "takehome"
    Project     = "devops-takehome"
  }
}