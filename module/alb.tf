  module "alb" {
    source = "terraform-aws-modules/alb/aws"
    name = var.alb_name
    load_balancer_type = "application"
    internal = var.internal
    vpc_id = var.vpc_id
    subnets = var.pub_subnet_ids
    security_groups = [module.alb-sg.security_group_id]
    
    target_groups = [
      {
          name_prefix = "target"
          backend_protocol = "HTTP"
          backend_port = var.container_port
          target_type = "ip"
          health_check = {
          matcher  = "200-499"
      }
      }
    ]

    http_tcp_listeners = [
      {
          port = 80
          protocol = "HTTP"
          target_group_index = 0
      }
    ]

    #  https_listeners = [
    # {
    #   port               = 443
    #   protocol           = "HTTPS"
    #   certificate_arn    = "arn:aws:acm:us-east-1:727085843824:certificate/f90c85e2-8f15-4edf-a01e-f29724f5c0fc"
    #   target_group_index = 0
    # } 
  #  ] 
   tags = var.tags
  }

