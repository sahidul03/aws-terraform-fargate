resource "aws_security_group" "ecs_alb_recurity_group" {
  name        = join("-", [var.ecs_cluster_name, "ALB", "SG"])
  description = "Security group for alb to traffic for ECS cluster"
  vpc_id      = data.terraform_remote_state.infrasturcture.outputs.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr_blocks]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_blocks]
  }

  tags = {
    Name = join("-", [var.ecs_cluster_name, "ALB", "SG"])
  }
}