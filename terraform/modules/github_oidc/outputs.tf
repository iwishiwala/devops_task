output "role_arn" {
  description = "IAM Role ARN for GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM Role ARN"
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN for GitHub"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_repo" {
  description = "GitHub repository that was detected or configured"
  value       = local.github_repo
}

output "github_branches" {
  description = "GitHub branches that can assume the role"
  value       = var.github_branches
}