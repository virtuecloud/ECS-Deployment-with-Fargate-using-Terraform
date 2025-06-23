variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment for the ECS services, e.g., dev, prod"
  type        = string
  
}

variable "services" {
  description = "Map of ECS services with their configurations"
  type        = map(object({
    internal                             = bool
    ecs_desired_count                    = number
    container_name                       = string
    ecs_service_name                     = string
    ecr_repo_uri                         = string
    container_port                       = number
    allocate_cpus                        = number
    allocate_memory                      = number
    health_check_grace_period_seconds    = number
    max_capacity                         = number
    min_capacity                         = number
    target_memory_utilization            = number
    target_cpu_utilization               = number
    envs                                 = list(map(string))
    secrets                              = list(map(string))
    host                                 = string
    listener_arn                         = string
    tags                                 = map(string)
  }))
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}
# variable "publicly_accessible"{}

variable "source_ecs_sg_id" {
  description = "This is the security group id for the ecs security group"
}