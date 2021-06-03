
# ALB rule
resource "aws_lb_listener_rule" "alb_rule" {
  listener_arn = var.LISTENER_ARN
  priority     = var.PRIORITY

  action {
    type             = "forward"
    target_group_arn = var.TARGET_GROUP_ARN
  }

  condition {
    field  = var.CONDITION_FIELD
    values = ["${var.CONDITION_VALUES}"]
  }
}
