locals {
  s3_origin_id = "${var.project_name}-s3-origin"
}

resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = "${var.project_name}-cloudfront-oai"
  description                       = "OAI for the cloudfornt used by the caiogomes.me app"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.s3_app_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.s3_cloudfront_logs_bucket.id}.s3.amazonaws.com"
    prefix          = "logs"
  }

  #   aliases = ["caiogomes.me"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }


  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket" "s3_cloudfront_logs_bucket" {
  bucket = "${var.project_name}-cloudfront-logs-bucket"

  tags = {
    "Name" = "${var.project_name}-cloudfront-logs-bucket"
  }
}

resource "aws_s3_bucket_acl" "s3_cloudfront_logs_bucket_acl" {
  bucket = aws_s3_bucket.s3_cloudfront_logs_bucket.id
  acl    = "private"
}
