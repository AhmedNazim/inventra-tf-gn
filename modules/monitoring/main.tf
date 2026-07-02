resource "aws_sns_topic" "alerts" {
  name = "${var.name_prefix}-alerts"

  tags = {
    Name = "${var.name_prefix}-alerts"
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/inventra/backend"
  retention_in_days = 7

  tags = {
    Name = "${var.name_prefix}-backend-logs"
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_backend" {
  alarm_name          = "${var.name_prefix}-ec2-cpu-backend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU de l'instance backend superieur a 80% pendant 10 minutes"
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = var.backend_instance_id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.name_prefix}-ec2-cpu-backend"
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_frontend" {
  alarm_name          = "${var.name_prefix}-ec2-cpu-frontend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU de l'instance frontend superieur a 80% pendant 10 minutes"
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = var.frontend_instance_id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.name_prefix}-ec2-cpu-frontend"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "${var.name_prefix}-rds-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Nombre de connexions PostgreSQL superieur a 50"
  treat_missing_data  = "missing"

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.name_prefix}-rds-connections"
  }
}
