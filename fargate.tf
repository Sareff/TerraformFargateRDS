resource "aws_security_group" "sg-ecs-task-2" {
  name   = "security-group-ecs-task-2"
  vpc_id = aws_vpc.vpc-task-2.id

  ingress {
    security_groups = [aws_security_group.sg-app-lb-task-2.id]
    from_port       = 8080
    protocol        = "tcp"
    to_port         = 8080
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "all"
    to_port     = 0
  }
}

resource "aws_ecr_repository" "web-53-ecr-task-2" {
  name = "web-53"
}

resource "aws_ecs_cluster" "web-53-ecs-task-2" {
  name = "web-53-cluster"
}
# Don't create on the real task
# resource "aws_cloudformation_stack" "cf-stack-task-2" {
#   name          = "cf-stack-task-2"
#   capabilities  = ["CAPABILITY_NAMED_IAM"]
#   template_body = file("config/core.yml")
# }

resource "aws_ecs_task_definition" "web-53-task" {
  family = "web-53-task"
  # Change arn for Roles
  task_role_arn      = "arn:aws:iam::680148905571:role/ECSTaskRole"
  execution_role_arn = "arn:aws:iam::680148905571:role/ECSServiceRole"
  ####
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions    = file("config/task-definition.json")
}

# Создание связанной роли не требуется, если ECS на аккаунте используется не впервые, но в ином случае код должен быть выполнен
# resource "aws_iam_service_linked_role" "MythicalMysfits-ECS-Linked" {
#   aws_service_name = "ecs.amazonaws.com"
# }

# resource "aws_autoscaling_group" "asg-task-2" {
#   name                = "asg-task-2"
#   vpc_zone_identifier = [aws_subnet.private-a1-task-2.id, aws_subnet.private-b1-task-2.id]
#   desired_capacity    = 1
#   min_size            = 1
#   max_size            = 4
#   default_cooldown    = 120
#   target_group_arns   = [aws_lb_target_group.app-lb-tg-task-2.arn]
# }

# resource "aws_autoscaling_policy" "as-policy-task-2" {
#   name                      = "as-policy-task-2"
#   policy_type               = "TargetTrackingScaling"
#   estimated_instance_warmup = 120

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ALBRequestCountPerTarget"
#       resource_label         = "${aws_lb.app-lb-task-2.arn_suffix}/${aws_lb_target_group.app-lb-tg-task-2.arn_suffix}"
#     }

#     target_value = 20
#   }

#   autoscaling_group_name = aws_autoscaling_group.asg-task-2.name
# }

# resource "aws_ecs_capacity_provider" "cap-prov-task-2" {
#   name = "cap-prov-task-2"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_autoscaling_group.asg-task-2.arn

#     managed_scaling {
#       maximum_scaling_step_size = 1000
#       minimum_scaling_step_size = 1
#       status                    = "ENABLED"
#       target_capacity           = 20
#     }
#   }
# }

resource "aws_appautoscaling_target" "ecs-target-task-2" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.web-53-ecs-task-2.name}/${aws_ecs_service.web-53-Service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs-policy-task-2" {
  name               = "scale-down"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-target-task-2.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-target-task-2.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-target-task-2.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.app-lb-task-2.arn_suffix}/${aws_lb_target_group.app-lb-tg-task-2.arn_suffix}"
    }

    target_value = 20
  }
}

resource "aws_ecs_service" "web-53-Service" {
  name                               = "web-53-Service"
  cluster                            = "web-53-cluster"
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1

  network_configuration {
    subnets         = [aws_subnet.private-a1-task-2.id, aws_subnet.private-b1-task-2.id]
    security_groups = [aws_security_group.sg-ecs-task-2.id]
  }

  task_definition = aws_ecs_task_definition.web-53-task.family

  load_balancer {
    container_name   = "web-53-task"
    container_port   = 8080
    target_group_arn = aws_lb_target_group.app-lb-tg-task-2.arn
  }
}