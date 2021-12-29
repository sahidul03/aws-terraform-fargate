provider "aws" {
  region  = var.region
  profile = "sahidboss"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "infrasturcture" {
  backend = "s3"

  config = {
    region = "ap-northeast-1"
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
  }
}

resource "aws_ecs_cluster" "production_fargate_cluster" {
  name = "Production_Fargate_Cluster"
}

resource "aws_lb" "ecs_cluster_alb" {
  name            = join("-", [var.ecs_cluster_name, "ALB"])
  internal        = false
  security_groups = [aws_security_group.ecs_alb_recurity_group.id]
  subnets         = [data.terraform_remote_state.infrasturcture.outputs.public_subnet_1_id, data.terraform_remote_state.infrasturcture.outputs.public_subnet_2_id]

  tags = {
    Name = join("-", [var.ecs_cluster_name, "ALB"])
  }
}

resource "aws_lb_listener" "ecs_alb_https_listener" {
  load_balancer_arn = aws_lb.ecs_cluster_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.ecs_domain_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
  }

  depends_on = [aws_lb_target_group.ecs_alb_target_group]
}

resource "aws_lb_target_group" "ecs_alb_target_group" {
  name     = join("-", [var.ecs_cluster_name, "ALB-target-group"])
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.infrasturcture.outputs.vpc_id

  tags = {
    Name = join("-", [var.ecs_cluster_name, "ALB-target-group"])
  }
}


resource "aws_route53_record" "ecs_load_balancer_record" {
  name    = "www.${var.ecs_domain_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.ecs_domain_name.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_lb.ecs_cluster_alb.dns_name
    zone_id                = aws_lb.ecs_cluster_alb.zone_id
  }
}

resource "aws_iam_role" "ecs_cluster_role_name" {
  name = join("-", [var.ecs_cluster_name, "Iam-Role"])

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ecs.amazonaws.com", "ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "ecs_cluster_policy" {
  name = join("-", [var.ecs_cluster_name, "Iam-Role-Policy"])
  role = aws_iam_role.ecs_cluster_role_name.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "ecr:*",
          "dynamodb:*",
          "cloudwatch:*",
          "s3:*",
          "rds:*",
          "sqs:*",
          "sns:*",
          "logs:*",
          "ssm:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
