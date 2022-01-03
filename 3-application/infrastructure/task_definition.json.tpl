[
    {
        "name": "${task_definition_name}",
        "image": "${docker_image_url}",
        "cpu": 512,
        "memory": 1024,
        "networkMode": "awsvpc",
        "portMappings": [{
            "containerPort": 80,
            "hostPort": 80
        }],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${ecs_service_name}-LogGroup",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "${ecs_service_name}-LogGroup-stream"
            } 
        }
    }
]