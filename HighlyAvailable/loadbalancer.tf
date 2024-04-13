locals {
  subnet_ids = [
    aws_subnet.ec2_1_public_subnet.id,
    aws_subnet.ec2_2_public_subnet.id
  ]
}

# Creation of application LoadBalancer
resource "aws_lb" "application_loadbalancer" {
  name               = "application-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.highlyavailable_instance_sg.id]
  subnets = [
    element(aws_subnet.ec2_1_public_subnet.*.id, 0),
    element(aws_subnet.ec2_2_public_subnet.*.id, 0)
  ]
  # subnets = var.subnet_ids
  tags = {
    Name = "application-loadbalancer"
  }
}

# Target group for application loadbalancer
resource "aws_lb_target_group" "target_group_alb" {
  name     = "target-group-alb"
  port     = var.target_application_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.highlyavailable_vpc.id

  tags = {
    Name = "target-group-alb"
  }
}


# Attach target group to instances
resource "aws_lb_target_group_attachment" "attachment" {
  count            = var.max_instances
  target_group_arn = aws_lb_target_group.target_group_alb.arn
  target_id        = element(aws_instance.highlyavailable_instance.*.id, count.index)
  port             = var.target_application_port

  depends_on = [
    aws_instance.highlyavailable_instance,
  ]
}

# Attach target group to a load balancer
resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.application_loadbalancer.arn
  port              = var.target_application_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_alb.arn
  }
}
