# Terraform-ECS-module 

<h1 align="center"> Virtuecloud </h1> <br>
<p align="center">
  <a href="https://virtuecloud.io/">
    <img alt="Virtuecloud" title="Virtuecloud" src="https://virtuecloud.io/assets/images/logo.png" width="450">
  </a>
</p>

# terraform-aws-ecs-fargate-module

A Terraform module to provision an ECS Fargate service (with Application Load Balancer, autoscaling, CloudWatch logs, and IAM) on AWS.

---

## Table of Contents

1. [Features](#features)  
2. [Requirements](#requirements)  
3. [Providers](#providers)  
4. [Module Usage](#module-usage)  
5. [Sample `terraform.tfvars`](#sample-terraformtfvars)  
6. [Module Inputs](#module-inputs)  
7. [Module Outputs](#module-outputs)  
8. [Root (Caller) Usage](#root-caller-usage)  
9. [Root Providers](#root-providers)  
10. [Root Outputs](#root-outputs)  
11. [License](#license)

---

## Features

- **ECS Fargate Service** with ALB target group & listener rule  
- **Autoscaling** on CPU & memory utilization  
- **Centralized logging** (CloudWatch Log Group)  
- **IAM roles & policies** for task execution, ECR pull, and Secrets Manager  
- **Security Group** module integration  

---

## Requirements

- Terraform ≥ 1.3  
- AWS provider ≥ 5.0  

---

## Providers

Place this in `module/providers.tf`:

```hcl
terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {}
```

---

## Module Usage

```hcl
module "ecs-services" {
  source            = "./module"
  depends_on        = [ aws_ecs_cluster.ecs_cluster ]
  for_each          = var.services

  # Core settings
  container_name    = "${each.value.container_name}-${var.env}"
  ecs_service_name  = "${each.value.ecs_service_name}-${var.env}"
  ecs_desired_count = each.value.ecs_desired_count
  container_port    = each.value.container_port

  # Networking
  vpc_id            = module.vpc.vpc_id
  priv_subnet_ids   = module.vpc.private_subnets
  cluster_arn       = aws_ecs_cluster.ecs_cluster.id

  # Image & resources
  ecr_repo_uri      = each.value.ecr_repo_uri
  allocate_cpus     = each.value.allocate_cpus
  allocate_memory   = each.value.allocate_memory

  # Tags
  tags              = each.value.tags

  # Env & Secrets
  task_environment_variables = each.value.envs
  task_secrets_variables     = each.value.secrets

  # Load Balancer & host-based routing
  source_ecs_sg_id           = var.source_ecs_sg_id
  listener_arn               = each.value.listener_arn
  host                       = each.value.host

  # Health check & autoscaling
  health_check_grace_period_seconds = each.value.health_check_grace_period_seconds
  cluster_name                      = aws_ecs_cluster.ecs_cluster.name
  max_capacity                      = each.value.max_capacity
  min_capacity                      = each.value.min_capacity
  target_memory_utilization         = each.value.target_memory_utilization
  target_cpu_utilization            = each.value.target_cpu_utilization
}
```

---

## Sample `terraform.tfvars`

```hcl
env                 = "dev"
cluster_name        = "sample-react-cluster"
source_ecs_sg_id    = "sg-0abc1234def567890"

services = {
  sample-service-1 = {
    internal                          = false
    ecs_desired_count                 = 1
    container_name                    = "sample-service-1"
    ecs_service_name                  = "sample-service-1"
    ecr_repo_uri                      = "123456789012.dkr.ecr.us-east-1.amazonaws.com/sample-service-1:latest"
    container_port                    = 3000
    allocate_cpus                     = 2048
    allocate_memory                   = 4096
    health_check_grace_period_seconds = 2147483647
    max_capacity                      = 2
    min_capacity                      = 1
    target_memory_utilization         = 80
    target_cpu_utilization            = 80
    envs = [
      { name = "ENV", value = "dev" },
    ]
    secrets = [
      { name = "ENV_VARS_JSON", valueFrom = "arn:aws:secretsmanager:...." },
    ]
    host         = "service1.example.com"
    listener_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/my-alb/abcd1234..."
    tags = {
      Application = "Service1"
    }
  }

  sample-service-2 = {
    internal                          = false
    ecs_desired_count                 = 1
    container_name                    = "sample-service-2"
    ecs_service_name                  = "sample-service-2"
    ecr_repo_uri                      = "123456789012.dkr.ecr.us-east-1.amazonaws.com/sample-service-2:latest"
    container_port                    = 8080
    allocate_cpus                     = 2048
    allocate_memory                   = 4096
    health_check_grace_period_seconds = 2147483647
    max_capacity                      = 2
    min_capacity                      = 1
    target_memory_utilization         = 80
    target_cpu_utilization            = 80
    envs = [
      { name = "ENV", value = "prod" },
    ]
    secrets = [
      { name = "ENV_VARS_JSON", valueFrom = "arn:aws:secretsmanager:...." },
    ]
    host         = "service2.example.com"
    listener_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/my-alb/ijkl9012..."
    tags = {
      Application = "Service2"
    }
  }
}
```

---

## Module Inputs

| Name                             | Type            | Required | Description                                                                                      |
|----------------------------------|-----------------|:--------:|--------------------------------------------------------------------------------------------------|
| `container_port`                 | `number`        |   yes    | Port exposed by the container.                                                                   |
| `ecs_desired_count`              | `number`        |   yes    | Initial desired number of tasks.                                                                 |
| `container_name`                 | `string`        |   yes    | Container name in the task definition.                                                           |
| `ecs_service_name`               | `string`        |   yes    | ECS service & task-definition family name.                                                       |
| `vpc_id`                         | `string`        |   yes    | VPC where the service & ALB live.                                                                |
| `priv_subnet_ids`                | `list(string)`  |   yes    | Private subnets for the Fargate tasks.                                                           |
| `cluster_arn`                    | `string`        |   yes    | ECS cluster ARN.                                                                                 |
| `ecr_repo_uri`                   | `string`        |   yes    | Full ECR URI (`account.dkr.ecr.region.amazonaws.com/repo:tag`).                                  |
| `allocate_cpus`                  | `number`        |   yes    | CPU units for each task (e.g. 256, 512, 1024, 2048).                                             |
| `allocate_memory`                | `number`        |   yes    | Memory (MiB) for each task (e.g. 512, 1024, 2048, 4096).                                         |
| `task_environment_variables`     | `list(map)`     |    no    | Environment variables for the container.                                                         |
| `task_secrets_variables`         | `list(map)`     |    no    | Secret mappings (`name`, `valueFrom`).                                                           |
| `source_ecs_sg_id`               | `string`        |   yes    | Security Group ID for ECS tasks to communicate with ALB.                                         |
| `host`                           | `string`        |   yes    | Host header to match in ALB listener rule.                                                       |
| `listener_arn`                   | `string`        |   yes    | ARN of the ALB listener (e.g. port 80/443).                                                      |
| `health_check_grace_period_seconds` | `number`     |   yes    | Grace period before ALB health checks start.                                                     |
| `env`                            | `string`        |   yes    | Deployment environment (e.g. `dev`, `prod`).                                                     |
| `cluster_name`                   | `string`        |   yes    | ECS cluster name (for autoscaling resource ID).                                                 |
| `max_capacity`                   | `number`        |   yes    | Maximum number of tasks in scaling target.                                                       |
| `min_capacity`                   | `number`        |   yes    | Minimum number of tasks in scaling target.                                                       |
| `target_memory_utilization`      | `number`        |   yes    | Autoscale target for average memory utilization (%).                                             |
| `target_cpu_utilization`         | `number`        |   yes    | Autoscale target for average CPU utilization (%).                                                |
| `tags`                           | `map(string)`   |   yes    | Tags applied to all resources.                                                                   |

---



## License

MIT
