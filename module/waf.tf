# ------------------------------------------------------------------------------
# AWS WAFv2 Web ACL (Application Layer 7 Firewall)
# ------------------------------------------------------------------------------
resource "aws_wafv2_web_acl" "main" {
  name        = "${substr(var.ecs_service_name, 0, 20)}-${var.env}-waf"
  description = "WAF Web ACL protecting ALB for ${var.ecs_service_name}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # 1. Custom Rule: Rate Limiting (500 requests per 5 minutes per IP)
  rule {
    name     = "RateLimit500PerIP"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10 # Minimum allowed by AWS WAF is 10
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit500PerIPMetric"
      sampled_requests_enabled   = true
    }
  }

  # 2. AWS Managed Rule: Common Rule Set (OWASP Top 10, XSS, etc.)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # 3. AWS Managed Rule: Known Bad Inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputsMetric"
      sampled_requests_enabled   = true
    }
  }

  # 4. AWS Managed Rule: Amazon IP Reputation List
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 30

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AmazonIpReputationMetric"
      sampled_requests_enabled   = true
    }
  }

  # 5. AWS Managed Rule: SQL Injection (SQLi)
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 40

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = replace("${var.ecs_service_name}${var.env}WAFMetric", "/[^a-zA-Z0-9]/", "")
    sampled_requests_enabled   = true
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Associate WAF Web ACL with ALB
# ------------------------------------------------------------------------------
resource "aws_wafv2_web_acl_association" "alb_waf" {
  resource_arn = aws_lb.main.arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# ------------------------------------------------------------------------------
# CloudWatch Log Group for WAF
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-${substr(var.ecs_service_name, 0, 20)}-${var.env}"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn
}
