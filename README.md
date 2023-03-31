# Terraform-ECS-module 
Terraform module to deploy AWS ECS Fargate

# Core Components

## AWS

_The AWS infrastructure is setup using terraform in the ./terraform._

_The following components are deployed:_

1. Application Load Balancer 
2. ECS Cluster / ECS Service 
3. security groups

# Usage

## ECS Module

```
module "ecs-dev" {
   source = "./module"
   depends_on=[ aws_ecs_cluster.example_cluster ]
   for_each = var.containers
   image_name = each.value.image_name
   container_name = each.value.container_name
   ecs_service_name = each.value.ecs_service_name 
   alb_name = each.value.alb_name
   internal = each.value.internal
   ecs_desired_count= each.value.ecs_desired_count
   container_port = each.value.container_port
   task_environment_variables = each.value.envs
   env_value = each.value.envs
   vpc_id = var.vpc_id
   pub_subnet_ids = var.pub_subnet_ids
   priv_subnet_ids = var.priv_subnet_ids
   cluster_arn = aws_ecs_cluster.example_cluster.id
  

}

```



# Note:
We did mapping in terraform.tfvars as:

```
vpc_id = "vpc-00c64060b3ce325fb"
pub_subnet_ids = ["subnet-0c3f8f6c0ab751452","subnet-0d88ccc1ef1c546a8","subnet-0315254f89b69b4c7"]
priv_subnet_ids= ["subnet-03834cfd9c6c45f70","subnet-03d282acf75f02722","subnet-055634ea4ba607d4e"]
cluster_name = "poc-frontend-dev"
containers={

    container1={

        ecs_desired_count = 1
        image_name = "nginx"
        container_name = "nginx" 
        ecs_service_name = "example-frontend-ecs-service"
        alb_name = "example-frontend-ecs"
        internal = true
        container_port=80
        
        env = [
          {name: "Example", value: "test"},
          {name: "Example2", value: "test2"}
        ]
    }
}   

```


# Inputs

|Name              |Description                                          |Type   |Default|
|------------------|-----------------------                              |-------|-------|
|container_name    |Name of your container                               |string |""     |
|ecs_service_name  |Name of the service                                  |string |""     |
|alb_name          |Name of your Load Balancer                           |string |""     |
|container_port    |Port on which it is going to be exposed              |number |       |
|internal          |For making Load balancer internal or internet facing |bool   |false  |
|ecs_desired_count |count of the task by your service at a moment        |number |1      |

# Outputs

|Name              |Description                        |                                    
|------------------|-----------------------            |                
|container_name    |Name that identifies the container |                   
|cluster_arn       |ARN that identifies the cluster    |                                                 









