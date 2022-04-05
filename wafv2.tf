resource "aws_wafv2_web_acl" "wafv2-acl-task-2" {
  name     = "wafv2-acl-task-2"
  scope    = "CLOUDFRONT"
  provider = aws.us_east_1_waf

  default_action {
    allow {
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "wafv2-acl-task-2"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWSManagedRulesSQLiRule"
    priority = 0
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRule"
      sampled_requests_enabled   = true
    }
  }
}