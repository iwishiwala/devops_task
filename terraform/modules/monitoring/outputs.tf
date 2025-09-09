output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for application logs"
  value       = aws_cloudwatch_log_group.app_logs.name
}

output "alarm_names" {
  description = "Names of the CloudWatch alarms"
  value = {
    high_cpu           = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
    high_memory        = aws_cloudwatch_metric_alarm.high_memory.alarm_name
    high_error_rate    = aws_cloudwatch_metric_alarm.high_error_rate.alarm_name
    unhealthy_hosts    = aws_cloudwatch_metric_alarm.unhealthy_hosts.alarm_name
    low_request_count  = aws_cloudwatch_metric_alarm.low_request_count.alarm_name
  }
}
