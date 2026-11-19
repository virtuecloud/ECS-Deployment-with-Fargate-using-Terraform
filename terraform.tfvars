aws_region   = "us-east-1"
env          = "dev"
cluster_name = "sample-waf-cluster"

# If left empty, will automatically use the created ALB security group
source_ecs_sg_id = ""

services = {
  sample-service-1 = {
    internal                          = false
    ecs_desired_count                 = 1 # 1 test task
    container_name                    = "sample-service-1"
    ecs_service_name                  = "sample-service-1"
    ecr_repo_uri                      = "public.ecr.aws/nginx/nginx:latest" # Official public Nginx image
    container_port                    = 80
    allocate_cpus                     = 256 # 0.25 vCPU (cost-effective for testing)
    allocate_memory                   = 512 # 512 MiB
    health_check_grace_period_seconds = 60
    max_capacity                      = 2
    min_capacity                      = 1
    target_memory_utilization         = 80
    target_cpu_utilization            = 80
    envs = [
      { "name" = "env", "value" = "dev" }
    ]
    secrets      = []  # No secrets needed for public nginx test
    host         = ""  # Empty string uses the ALB listener default forward action (matches all traffic)
    listener_arn = ""  # Will automatically bind to the created ALB listener
    tags = {
      application_name = "nginx-sample"
      resourceowner    = "ankush.mishra"
      Environment      = "dev"
      Project          = "poc"
    }
  }

  # Uncomment sample-service-2 below when you are ready to test multi-service routing:
  # sample-service-2 = {
  #   internal                          = false
  #   ecs_desired_count                 = 1
  #   container_name                    = "sample-service-2"
  #   ecs_service_name                  = "sample-service-2"
  #   ecr_repo_uri                      = "public.ecr.aws/nginx/nginx:latest"
  #   container_port                    = 80
  #   allocate_cpus                     = 256
  #   allocate_memory                   = 512
  #   health_check_grace_period_seconds = 60
  #   max_capacity                      = 2
  #   min_capacity                      = 1
  #   target_memory_utilization         = 80
  #   target_cpu_utilization            = 80
  #   envs = [
  #     { "name" = "env", "value" = "prod" }
  #   ]
  #   secrets = []
  #   host    = "service2.example.com"
  #   listener_arn = ""
  #   tags = {
  #     application_name = "Service2"
  #     resourceowner    = "ankush.mishra"
  #     Environment      = "dev"
  #     Project          = "poc"
  #   }
  # }
}
