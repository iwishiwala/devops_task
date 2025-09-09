output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.eks_irsa.arn
}

output "lb_controller_role_arn" {
  description = "Load balancer controller IAM role ARN"
  value       = aws_iam_role.lb_controller.arn
}
