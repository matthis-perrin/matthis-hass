output "widget_cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.widget.domain_name
  description = "Domain (from cloudfront) where the \"matthis-hass-widget\" frontend is available."
}
  
resource "aws_cloudfront_distribution" "widget" {
  origin {
    domain_name = aws_s3_bucket.code.bucket_regional_domain_name
    origin_id   = "widget-origin-id"
    origin_path = "/widget"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.widget.cloudfront_access_identity_path
    }
  }
  
  enabled             = true
  wait_for_deployment = false
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  
  default_root_object   = "/index.html"
  custom_error_response {
    error_code         = 400
    response_code      = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    compress         = true
    target_origin_id = "widget-origin-id"
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
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

resource "aws_cloudfront_origin_access_identity" "widget" {}