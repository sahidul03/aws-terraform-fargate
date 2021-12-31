#remote state
remote_state_key    = "PROD/platform.tfstate"
remote_state_bucket = "sahid-fargate-terraform-remote-state"

ecs_service_name      = "railsapp"
docker_container_port = 8080
desired_task_number   = 2
rails_profile         = "default"
memory                = 1024