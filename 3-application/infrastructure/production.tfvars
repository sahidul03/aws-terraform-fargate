#remote state
remote_state_key    = "PROD/platform.tfstate"
remote_state_bucket = "sahid-fargate-terraform-remote-state"

ecs_service_name      = "railsapp"
docker_container_port = 80
desired_task_number   = 2
memory                = 1024