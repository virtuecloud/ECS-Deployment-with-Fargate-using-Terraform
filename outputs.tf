output "ecs_service_arns" {
  description = "Map of ECS service ARNs by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.service_arn }
}

output "ecs_service_names" {
  description = "Map of ECS service names by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.service_name }
}

output "target_group_arns" {
  description = "Map of ALB target group ARNs by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.target_group_arn }
}

output "listener_rule_arns" {
  description = "Map of ALB listener rule ARNs by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.listener_rule_arn }
}

output "log_group_names" {
  description = "Map of CloudWatch Log Group names by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.log_group_name }
}
