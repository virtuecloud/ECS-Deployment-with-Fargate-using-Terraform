aws_region = "us-east-1"
cluster_name = "sample-react-cluster"
# publicly_accessible = true
source_ecs_sg_id = ""
services={

    sample-service-1={
        internal = false
        ecs_desired_count = 1  # Number of containers running
        container_name = "sample-service-1"
        ecs_service_name = "sample-service-1"
        ecr_repo_uri = ""
        container_port= 3000 #eg-4000
        allocate_cpus=2048
        allocate_memory=4096
        health_check_grace_period_seconds = 2147483647
        max_capacity = 2
        min_capacity = 1
        target_memory_utilization = 80
        target_cpu_utilization = 80
        envs = [
            {"name" = "env", "value" = "dev"},
        ]
        secrets = [
            { "name" = "ENV_VARS_JSON", "valueFrom" = "" },            

        ]
        host = ""
        listener_arn = ""
        tags = {
            application_name  = "Service"
        }
     }

     sample-service-2={
        internal = false
        ecs_desired_count = 1  # Number of containers running
        container_name = "sample-service-2"
        ecs_service_name = "sample-service-2"
        ecr_repo_uri = ""
        container_port= 8080 #eg-4000
        allocate_cpus=2048
        allocate_memory=4096
        health_check_grace_period_seconds = 2147483647
        max_capacity = 2
        min_capacity = 1
        target_memory_utilization = 80
        target_cpu_utilization = 80
        envs = [
            {"name" = "env", "value" = "prod"},
        ]
        secrets = [
            { "name" = "ENV_VARS_JSON", "valueFrom" = "" },            

        ]
        host = ""
        listener_arn = ""
        tags = {
            application_name  = "Service"
        }
     }

}
  