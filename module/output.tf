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
  value       = aws_lb_listener_rule.static.arn
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
