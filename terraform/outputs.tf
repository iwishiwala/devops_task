############################################################
# Outputs
############################################################
data "aws_caller_identity" "current" {}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "cluster_name" {
  description = "ECS Cluster Name"
  value       = module.ecs.cluster_name
}

output "cluster_arn" {
  description = "ECS Cluster ARN"
  value       = module.ecs.cluster_arn
}

output "cluster_id" {
  description = "ECS Cluster ID"
  value       = module.ecs.cluster_id
}

output "service_name" {
  description = "ECS Service Name"
  value       = module.ecs.service_name
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = module.ecs.alb_dns_name
}

output "alb_zone_id" {
  description = "Application Load Balancer Zone ID"
  value       = module.ecs.alb_zone_id
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = module.ecs.alb_arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecs_task_execution_role_arn" {
  description = "ECS Task Execution Role ARN"
  value       = module.ecs.ecs_task_execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ECS Task Role ARN"
  value       = module.ecs.ecs_task_role_arn
}

output "target_group_arn" {
  description = "ALB Target Group ARN"
  value       = module.ecs.target_group_arn
}

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "ECR Repository Name"
  value       = module.ecr.repository_name
}

output "ecr_repository_arn" {
  description = "ECR Repository ARN"
  value       = module.ecr.repository_arn
}

output "ecr_registry_id" {
  description = "ECR Registry ID"
  value       = module.ecr.registry_id
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM Role ARN"
  value       = module.github_oidc.github_actions_role_arn
}

output "github_repo" {
  description = "GitHub repository detected for OIDC authentication"
  value       = module.github_oidc.github_repo
}

output "github_branches" {
  description = "GitHub branches that can assume the OIDC role"
  value       = module.github_oidc.github_branches
}

# Monitoring outputs
output "monitoring_dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = module.monitoring.dashboard_url
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = module.monitoring.sns_topic_arn
}

output "alarm_names" {
  description = "Names of the CloudWatch alarms"
  value       = module.monitoring.alarm_names
}

# Secrets outputs
output "secret_arns" {
  description = "ARNs of the created secrets"
  value       = module.secrets.secret_arns
  sensitive   = true
}

# HTTPS outputs (only if domain is configured)
output "https_enabled" {
  description = "Whether HTTPS is enabled"
  value       = var.domain_name != ""
}

output "certificate_arn" {
  description = "ARN of the SSL certificate (if HTTPS enabled)"
  value       = var.domain_name != "" ? module.https[0].certificate_arn : null
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener (if HTTPS enabled)"
  value       = var.domain_name != "" ? module.https[0].https_listener_arn : null
}