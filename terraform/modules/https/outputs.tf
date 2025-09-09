output "certificate_arn" {
  description = "ARN of the SSL certificate"
  value       = var.domain_name != "" ? aws_acm_certificate.main[0].arn : null
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = var.domain_name != "" ? aws_lb_listener.https[0].arn : null
}

output "domain_name" {
  description = "Domain name for the certificate"
  value       = var.domain_name
}
