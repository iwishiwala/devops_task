output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  value       = data.aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_auth_token" {
  description = "EKS cluster auth token"
  value       = data.aws_eks_cluster_auth.cluster.token
  sensitive   = true
}
