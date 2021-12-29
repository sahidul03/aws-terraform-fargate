#remote state
remote_state_key    = "PROD/infrasturcture.tfstate"
remote_state_bucket = "sahid-fargate-terraform-remote-state"

ecs_domain_name      = "sahid.xyz"
ecs_cluster_name     = "Production-ECS-Cluster"
internet_cidr_blocks = "0.0.0.0/0"