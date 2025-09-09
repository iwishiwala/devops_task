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

  # Secrets access
  secrets_access_policy_arn = module.secrets.secrets_access_policy_arn

  tags = {
    Environment = "takehome"
    Project     = "devops-takehome"
  }
}

# IAM/IRSA for GitHub Actions
module "github_oidc" {
  source = "./modules/github_oidc"

  # Auto-detects repository from git remote if not specified
  # github_repo = "iwishiwala/devops_task"  # Optional: override auto-detection
  
  # Supports multiple branches
  github_branches = ["main", "develop"]
  
  # Role name (optional, defaults to "github-actions")
  role_name = "github-actions"

  tags = {
    Environment = "takehome"
    Project     = "devops-takehome"
  }
}

# Monitoring and Alerting
module "monitoring" {
  source = "./modules/monitoring"

  cluster_name      = module.ecs.cluster_name
  service_name      = module.ecs.service_name
  alb_arn          = module.ecs.alb_arn
  target_group_arn = module.ecs.target_group_arn

  # Configure alerting (optional)
  notification_email = ""  # Set your email for alerts
  # slack_webhook_url = "" # Set Slack webhook URL for alerts

  tags = {
    Environment = "takehome"
    Project     = "devops-takehome"
  }
}

# Secrets Management
module "secrets" {
  source = "./modules/secrets"

  # Define application secrets
  secrets = {
    "app/database-url" = {
      description = "Database connection URL"
      value       = "postgresql://user:password@localhost:5432/mydb"
      tags = {
        Environment = "takehome"
        Project     = "devops-takehome"
      }
    }
    "app/api-key" = {
      description = "External API key"
      value       = "your-api-key-here"
      tags = {
        Environment = "takehome"
        Project     = "devops-takehome"
      }
    }
  }

  tags = {
    Environment = "takehome"
    Project     = "devops-takehome"
  }
}

# HTTPS/TLS (optional - requires domain name)
# module "https" {
#   source = "./modules/https"
#   
#   domain_name        = "your-domain.com"  # Set your domain name
#   alb_arn           = module.ecs.alb_arn
#   alb_listener_arn  = module.ecs.alb_listener_arn
#   target_group_arn  = module.ecs.target_group_arn
#   
#   tags = {
#     Environment = "takehome"
#     Project     = "devops-takehome"
#   }
# }