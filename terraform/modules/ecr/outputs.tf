output "repository_id" {
  description = "ECR Repository ID"
  value       = aws_ecr_repository.main.id
}

output "repository_arn" {
  description = "ECR Repository ARN"
  value       = aws_ecr_repository.main.arn
}

output "repository_name" {
  description = "ECR Repository Name"
  value       = aws_ecr_repository.main.name
}

output "repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.main.repository_url
}

output "registry_id" {
  description = "ECR Registry ID"
  value       = aws_ecr_repository.main.registry_id
}

output "lifecycle_policy_id" {
  description = "ECR Lifecycle Policy ID"
  value       = aws_ecr_lifecycle_policy.main.id
}
