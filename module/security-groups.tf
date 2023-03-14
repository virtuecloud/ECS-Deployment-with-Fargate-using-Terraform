module "alb-sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "alb-sg-ecs-${var.ecs_service_name}"
  description = "Security group for ecs usage with ALB"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  egress_rules        = ["all-all"]
  # depends_on = [aws_cloudwatch_log_group.example_cw_log_group]
}

module "ecs-sg" {
  source = "terraform-aws-modules/security-group/aws"
  # depends_on = [aws_cloudwatch_log_group.example_cw_log_group]
  name = "ecs-sg-${var.ecs_service_name}"
  description = "ecs security group"
  vpc_id = var.vpc_id
  ingress_with_source_security_group_id = [
    {
      rule = "all-tcp"
      source_security_group_id = module.alb-sg.security_group_id
    }
  ]
  
  # ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules       = ["all-tcp"]
  egress_rules        = ["all-all"]
}