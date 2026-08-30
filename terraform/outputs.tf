output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]
}

output "app_subnet_ids" {
  description = "Application subnet IDs"
  value = [
    aws_subnet.app_az1.id,
    aws_subnet.app_az2.id
  ]
}

output "db_subnet_ids" {
  description = "Database subnet IDs"
  value = [
    aws_subnet.db_az1.id,
    aws_subnet.db_az2.id
  ]
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

#security-groups

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Application security group ID"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "Database security group ID"
  value       = aws_security_group.db.id
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "Application Target Group ARN"
  value       = aws_lb_target_group.app.arn
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.app.name
}

# RDS

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.main.address
}

output "rds_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.main.db_name
}