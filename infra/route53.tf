resource "aws_route53_record" "r53_cloudfront_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "caiogomes.me"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
