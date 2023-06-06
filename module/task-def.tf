resource "aws_ecs_task_definition" "example_task_def" {
  # depends_on = [aws_cloudwatch_log_group.example_cw_log_group]
  family = var.ecs_service_name
  container_definitions = jsonencode(
[
  {
    "name": "${var.ecs_service_name}",
    "image": "${aws_ecr_repository.foo.repository_url}:latest",
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": var.container_port,
        "hostPort": var.container_port
      }
    ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/${var.ecs_service_name}",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
          }
        },
      //  "environment": var.task_environment_variables == [] ? null : var.task_environment_variables
  }
] )


  cpu = 1024
  memory = 2048
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.task_def_role.arn
  task_role_arn = aws_iam_role.task_def_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
  }
}
resource "aws_iam_role" "task_def_role" {
  name = "${var.ecs_service_name}_task_def_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy" "ecr-iam-policy" {
  name = "${var.ecs_service_name}_task_def_policy"
  role = aws_iam_role.task_def_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
})
}
resource "aws_iam_role_policy" "secret-manager" {
  name = "${var.ecs_service_name}_task_def_policy_secret_manager"
  role = aws_iam_role.task_def_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "secretsmanager:*",
                "cloudformation:CreateChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:DescribeStackResource",
                "cloudformation:DescribeStacks",
                "cloudformation:ExecuteChangeSet",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "kms:DescribeKey",
                "kms:ListAliases",
                "kms:ListKeys",
                "lambda:ListFunctions",
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances",
                "redshift:DescribeClusters",
                "tag:GetResources"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },

    ]
})
}