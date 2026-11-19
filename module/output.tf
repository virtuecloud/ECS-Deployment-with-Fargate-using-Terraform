output "service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.ecs-service.name
}

output "service_arn" {
  description = "ARN of the ECS service."
  value       = aws_ecs_service.ecs-service.arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group."
  value       = aws_lb_target_group.ecs-ip-tg.arn
}

output "listener_rule_arn" {
  description = "ARN of the ALB listener rule."
  value       = try(aws_lb_listener_rule.static[0].arn, "")
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group."
  value       = aws_cloudwatch_log_group.cw_log_group.name
}

output "autoscaling_policy_cpu_arn" {
  description = "ARN of the CPU autoscaling policy."
  value       = aws_appautoscaling_policy.autoscale_cpu.arn
}

output "autoscaling_policy_memory_arn" {
  description = "ARN of the memory autoscaling policy."
  value       = aws_appautoscaling_policy.autoscale_memory.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_listener_arn" {
  description = "ARN of the ALB HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "alb_security_group_id" {
  description = "Security group ID of the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "waf_web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "waf_web_acl_id" {
  description = "ID of the WAFv2 Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "waf_log_group_name" {
  description = "Name of the CloudWatch Log Group for WAF"
  value       = aws_cloudwatch_log_group.waf_logs.name
}
