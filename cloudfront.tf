resource "aws_cloudfront_distribution" "cf-d-task-2" {
  web_acl_id = aws_wafv2_web_acl.wafv2-acl-task-2.arn
  enabled    = true

  origin {
    domain_name = aws_lb.app-lb-task-2.dns_name
    origin_id   = "ELB-${aws_lb.app-lb-task-2.id}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ELB-${aws_lb.app-lb-task-2.id}"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}