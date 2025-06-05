resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_groups" {
  for_each = var.target_groups

  name     = "${each.value.name}-tg"
  port     = each.value.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_groups["homepage"].arn
  }
}

resource "aws_lb_listener_rule" "path_based" {
  for_each = {
    for k, v in var.target_groups : k => v if k != "default"
  }

  listener_arn = aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_groups[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }
}
