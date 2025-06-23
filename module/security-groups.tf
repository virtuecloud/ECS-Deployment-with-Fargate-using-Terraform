module "ecs-sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  name = "ecs-sg-${var.ecs_service_name}"
  description = "ecs security group"
  vpc_id = var.vpc_id
  ingress_with_source_security_group_id = [
    {
      rule = "all-tcp"
      source_security_group_id = var.source_ecs_sg_id
    }
  ]
  egress_rules        = ["all-all"]
  tags = var.tags
}