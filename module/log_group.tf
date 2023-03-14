 resource "aws_cloudwatch_log_group" "example_cw_log_group" {
   name = "/ecs/${var.ecs_service_name}"

   tags = {
     Environment = "stage"
     Application = "${var.ecs_service_name}"
   }
 }