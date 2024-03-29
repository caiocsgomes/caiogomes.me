resource "aws_acm_certificate" "cert" {
  domain_name       = var.project_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.useast1
}

resource "aws_route53_record" "r53_validation_route" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}
