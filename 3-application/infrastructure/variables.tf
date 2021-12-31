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
variable "rails_profile" {}
variable "desired_task_number" {}
variable "docker_image_url" {}