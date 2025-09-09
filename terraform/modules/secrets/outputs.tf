output "secret_arns" {
  description = "ARNs of the created secrets"
  value       = { for k, v in aws_secretsmanager_secret.secrets : k => v.arn }
}

output "secrets_access_policy_arn" {
  description = "ARN of the IAM policy for secrets access"
  value       = length(aws_iam_policy.secrets_access) > 0 ? aws_iam_policy.secrets_access[0].arn : null
}
