output "vpc_id" {
  value = data.terraform_remote_state.infrasturcture.outputs.vpc_id
}

output "vpc_cidr_block" {
  value = data.terraform_remote_state.infrasturcture.outputs.vpc_cidr_block
}

output "ecs_alb_listener_arn" {
  value = aws_lb_listener.ecs_alb_https_listener.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.production_fargate_cluster.name
}

output "ecs_cluster_role_name" {
  value = aws_iam_role.ecs_cluster_role_name.name
}

output "ecs_cluster_role_arn" {
  value = aws_iam_role.ecs_cluster_role_name.arn
}

output "ecs_domain_name" {
  value = var.ecs_domain_name
}

output "ecs_public_subnets" {
  value = [data.terraform_remote_state.infrasturcture.outputs.public_subnet_1_id, data.terraform_remote_state.infrasturcture.outputs.public_subnet_2_id]
}

output "ecs_private_subnets" {
  value = [data.terraform_remote_state.infrasturcture.outputs.private_subnet_1_id, data.terraform_remote_state.infrasturcture.outputs.private_subnet_2_id]
}
