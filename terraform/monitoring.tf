# CLOUDWATCH MONITORING & ALERTS

# SNS TOPIC
resource "aws_sns_topic" "alerts" {
  name = "aws-3-tier-alerts"
}

# SNS EMAIL SUBSCRIPTION
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ALB - 5XX ERROR ALARM
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "aws-3-tier-alb-5xx"
  alarm_description   = "ALB is returning 5XX errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  dimensions = {
    LoadBalancer = split("loadbalancer/", aws_lb.app.arn)[1]
  }

  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.alerts.arn]
}

# ALB - UNHEALTHY TARGETS ALARM
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "aws-3-tier-alb-unhealthy-targets"
  alarm_description   = "ALB has unhealthy targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions = {
    LoadBalancer = split("loadbalancer/", aws_lb.app.arn)[1]
    TargetGroup  = split("targetgroup/", aws_lb_target_group.app.arn)[1]
  }

  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.alerts.arn]
}

# RDS - CPU ALARM
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "aws-3-tier-rds-high-cpu"
  alarm_description   = "RDS CPU utilization is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.alerts.arn]
}

# RDS - FREE STORAGE SPACE ALARM
resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "aws-3-tier-rds-low-storage"
  alarm_description   = "RDS free storage space is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 2147483648 # 2 GB

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.alerts.arn]
}

# RDS - DATABASE CONNECTIONS ALARM
resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "aws-3-tier-rds-connections"
  alarm_description   = "RDS database connections are high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.alerts.arn]
}

# EC2 - CPU ALARM
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name          = "aws-3-tier-ec2-high-cpu"
  alarm_description   = "Application EC2 CPU utilization is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.alerts.arn]
}