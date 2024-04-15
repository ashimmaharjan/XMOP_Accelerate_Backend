# Create a target group
resource "aws_lb_target_group" "wordpress_target_group" {
  name        = "wordpress-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 50
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create a load balancer
resource "aws_lb" "wordpress_load_balancer" {
  name               = "wordpress-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg-group.id]
  subnets            = [aws_subnet.public-subnet-1.id,aws_subnet.public-subnet-2.id]

  enable_deletion_protection = false
}

# Create an ALB listener
resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  }
}

// Create a CloudWatch Alarm for ALB request count
resource "aws_cloudwatch_metric_alarm" "alb_request_count_alarm" {
  alarm_name          = "ALBRequestCountAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 2  // Adjust threshold as needed
  alarm_description   = "Alarm when ALB request count exceeds threshold"
  alarm_actions       = [aws_sns_topic.my_topic.arn]
}
 