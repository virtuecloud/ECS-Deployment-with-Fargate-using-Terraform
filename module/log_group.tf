resource "aws_cloudwatch_log_group" "cw_log_group" {
  name = "/ecs/${var.ecs_service_name}"

  tags = var.tags
}