# Deploy ALB Controller via Helm
resource "helm_release" "aws_load_balancer_controller" {
  name       = var.release_name
  repository = var.repository
  chart      = var.chart_name
  namespace  = var.namespace

  values = [
    yamlencode({
      clusterName = var.cluster_id
      serviceAccount = {
        create = false
        name   = var.service_account_name
      }
      region = var.aws_region
      vpcId  = var.vpc_id
    })
  ]

  depends_on = [var.irsa_dependency]
}
