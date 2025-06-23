 resource "aws_appautoscaling_target" "autoscale_target" {
    depends_on = [ aws_ecs_service.ecs-service ]
    max_capacity = var.max_capacity
    min_capacity = var.min_capacity
    resource_id = "service/${var.cluster_name}-${var.env}/${var.ecs_service_name}"
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace = "ecs"
    tags = var.tags
}
resource "aws_appautoscaling_policy" "autoscale_memory" {
    depends_on = [ aws_ecs_service.ecs-service ]
    name               = "${var.ecs_service_name}-to-memory"
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.autoscale_target.resource_id
    scalable_dimension = aws_appautoscaling_target.autoscale_target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.autoscale_target.service_namespace
    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageMemoryUtilization"
        }
        target_value       = var.target_memory_utilization
    }
}
resource "aws_appautoscaling_policy" "autoscale_cpu" {
    depends_on = [ aws_ecs_service.ecs-service ]
    name = "${var.ecs_service_name}-to-cpu"
    policy_type = "TargetTrackingScaling"
    resource_id = aws_appautoscaling_target.autoscale_target.resource_id
    scalable_dimension = aws_appautoscaling_target.autoscale_target.scalable_dimension
    service_namespace = aws_appautoscaling_target.autoscale_target.service_namespace
    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageCPUUtilization"
        }
        target_value = var.target_cpu_utilization
    }
}












