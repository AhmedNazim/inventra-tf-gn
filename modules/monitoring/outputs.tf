output "sns_topic_arn" {
  description = "ARN du topic SNS des alertes"
  value       = aws_sns_topic.alerts.arn
}

output "log_group_name" {
  description = "Nom du log group CloudWatch du backend"
  value       = aws_cloudwatch_log_group.backend.name
}
