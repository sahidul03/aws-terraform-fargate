data "aws_route53_zone" "ecs_domain_name" {
  name         = var.ecs_domain_name
}

resource "aws_route53_record" "demo_sahid" {
  zone_id = data.aws_route53_zone.ecs_domain_name.zone_id
  name    = join(".", ["demo", var.ecs_domain_name])
  type    = "A"
  alias {
    name                   = aws_lb.ecs_cluster_alb.dns_name
    zone_id                = aws_lb.ecs_cluster_alb.zone_id
    evaluate_target_health = false
  }
  depends_on = [
    aws_lb.ecs_cluster_alb
  ]
}

resource "aws_acm_certificate" "demo_sahid" {
  domain_name               = aws_route53_record.demo_sahid.name
  subject_alternative_names = ["*.${aws_route53_record.demo_sahid.name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "demo_sahid_certificate" {
  for_each = {
    for option in aws_acm_certificate.demo_sahid.domain_validation_options : option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  }
  zone_id         = data.aws_route53_zone.ecs_domain_name.zone_id
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
}

resource "aws_acm_certificate_validation" "demo_sahid_validation_certificate" {
  certificate_arn         = aws_acm_certificate.demo_sahid.arn
  validation_record_fqdns = [for record in aws_route53_record.demo_sahid_certificate : record.fqdn]
}
