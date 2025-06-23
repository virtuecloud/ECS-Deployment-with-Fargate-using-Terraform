variable "container_port" {
    type = number
    description = "Port to expose for the app running in container"
}

variable "ecs_desired_count" {
    type = number
    description = "Desired count of task to run"
}

variable "container_name" {
    type = string
    description = "Name of the container to run a task in"
}

variable "ecs_service_name" {
    type = string
    description = "Ecs service name"
}

variable "vpc_id" {
    description = "vpc id"
}

variable "priv_subnet_ids" {
    description = "Private subnet ids"
}

variable "cluster_arn" {
    type = string
    description = "ARN of the cluster"
    
}


variable "ecr_repo_uri" {
    description = "This is the URI of the ecr repository"

}

variable "tags" {
    description = "Tags to add to all resources in the module"
}

variable "allocate_cpus" {
    description = "The Number of CPUs to allocate to ECS task for running properly" 
}

variable "allocate_memory" {
    description = "The Memory which needs to be allocated to ECS task"
}

variable "task_environment_variables"{
    description = "Task environment variables for presto services"
}

variable "task_secrets_variables"{
    description = "Task secrets variables for presto services"
}

variable "source_ecs_sg_id" {
    description = "This is the security group id for the ecs security group"
}

variable "host" {

}
variable "listener_arn" {
  
}
# variable "priority" {
  
# }

variable "load_balancing_cross_zone_enabled" {
  default = true
}

variable "health_check_grace_period_seconds" {
  
}

variable "env" {
  
}
variable "max_capacity" {
  
}

variable "min_capacity" {
  
}

variable "cluster_name" {
  
}



variable "target_memory_utilization" {
  
}

variable "target_cpu_utilization" {
  
}