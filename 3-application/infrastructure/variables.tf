variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "remote_state_bucket" {}
variable "remote_state_key" {}


variable "ecs_service_name" {}
variable "memory" {}
variable "docker_container_port" {}
variable "desired_task_number" {}
variable "docker_image_url" {
  default = "685670624701.dkr.ecr.us-east-1.amazonaws.com/test_nodejs_ecr_repo:2"
}