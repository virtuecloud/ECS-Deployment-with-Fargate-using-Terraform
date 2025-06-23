module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

}


 resource "aws_ecs_cluster" "ecs_cluster" {
   name = var.cluster_name
} 


module "ecs-services" {
    source = "./module"
    depends_on=[ aws_ecs_cluster.ecs_cluster]
    for_each = var.services
    container_name = "${each.value.container_name}-${var.env}"
    ecs_service_name = "${each.value.ecs_service_name}-${var.env}" 
    ecs_desired_count= each.value.ecs_desired_count
    container_port = each.value.container_port
    vpc_id = module.vpc.vpc_id
    # vpc_id = var.vpc_id
    # priv_subnet_ids = var.priv_subnet_ids
    priv_subnet_ids = module.vpc.private_subnets
    cluster_arn = aws_ecs_cluster.ecs_cluster.id
    ecr_repo_uri = each.value.ecr_repo_uri
    allocate_cpus = each.value.allocate_cpus
    allocate_memory = each.value.allocate_memory
    tags = each.value.tags
    task_environment_variables = each.value.envs
    task_secrets_variables     = each.value.secrets
    # source_ecs_sg_id           = each.value.internal == true ? module.ecs_alb_private.security_group_id : module.ecs_alb_public.security_group_id
    source_ecs_sg_id           = var.source_ecs_sg_id
    env                        = var.env
    host = each.value.host
    # load_balancing_cross_zone_enabled = each.value.load_balancing_cross_zone_enabled
    # listener_arn = each.value.internal == true ? module.ecs_alb_private.listener_arn : module.ecs_alb_public.listener_arn
    listener_arn = each.value.listener_arn
    health_check_grace_period_seconds = each.value.health_check_grace_period_seconds
    cluster_name = aws_ecs_cluster.ecs_cluster.name
    max_capacity = each.value.max_capacity
    min_capacity = each.value.min_capacity
    target_memory_utilization = each.value.target_memory_utilization
    target_cpu_utilization = each.value.target_cpu_utilization
    
}