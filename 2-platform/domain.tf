resource "aws_acm_certificate" "ecs_domain_certificate" {
  domain_name       = "www.${var.ecs_domain_name}"
  validation_method = "DNS"

  tags = {
    Environment = "Production"
    Name        = join("-", [var.ecs_cluster_name, "domain_certificates"])
  }
}

data "aws_route53_zone" "ecs_domain_name" {
  name         = var.ecs_domain_name
}

resource "aws_route53_record" "ecs_certificate_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.ecs_domain_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.ecs_domain_name.zone_id
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 500
  type            = each.value.type
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "ecs_domain_certificate_validation" {
  certificate_arn         = aws_acm_certificate.ecs_domain_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.ecs_certificate_validation_record : record.fqdn]
}
