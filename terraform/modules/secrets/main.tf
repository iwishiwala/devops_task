# Create secrets in AWS Secrets Manager
resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets

  name                    = each.key
  description             = each.value.description
  recovery_window_in_days = 7

  tags = merge(var.tags, each.value.tags)
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each = var.secrets

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.value
}

# IAM policy for ECS tasks to access secrets
resource "aws_iam_policy" "secrets_access" {
  count = length(var.secrets) > 0 ? 1 : 0

  name        = "ecs-secrets-access"
  description = "Policy for ECS tasks to access secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [for secret in aws_secretsmanager_secret.secrets : secret.arn]
      }
    ]
  })

  tags = var.tags
}
