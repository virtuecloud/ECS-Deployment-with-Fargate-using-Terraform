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

output "alb_dns_names" {
  description = "Public DNS names of the Application Load Balancers by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.alb_dns_name }
}

output "alb_arns" {
  description = "ARNs of the Application Load Balancers by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.alb_arn }
}

output "alb_listener_arns" {
  description = "ARNs of the ALB HTTP listeners by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.alb_listener_arn }
}

output "alb_security_group_ids" {
  description = "Security Group IDs of the Application Load Balancers by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.alb_security_group_id }
}

output "waf_web_acl_arns" {
  description = "ARNs of the WAFv2 Web ACLs by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.waf_web_acl_arn }
}

output "waf_web_acl_ids" {
  description = "IDs of the WAFv2 Web ACLs by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.waf_web_acl_id }
}

output "waf_log_group_names" {
  description = "CloudWatch Log Group names for WAF logs by service key."
  value       = { for svc, inst in module.ecs-services : svc => inst.waf_log_group_name }
}
