output "release_name" {
  description = "Helm release name"
  value       = helm_release.aws_load_balancer_controller.name
}

output "release_namespace" {
  description = "Helm release namespace"
  value       = helm_release.aws_load_balancer_controller.namespace
}

output "release_status" {
  description = "Helm release status"
  value       = helm_release.aws_load_balancer_controller.status
}
