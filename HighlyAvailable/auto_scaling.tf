resource "aws_launch_configuration" "launchconfig" {
  name            = "highlyavailable_autoscale"
  image_id        = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.highlyavailable_instance_sg.id]
  user_data       = file("install_script.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name                 = "wordpress-asg"
  launch_configuration = aws_launch_configuration.launchconfig.id
  min_size             = var.max_instances
  max_size             = var.max_instances
  desired_capacity     = var.max_instances
  vpc_zone_identifier = [
    aws_subnet.ec2_1_public_subnet.id,
    aws_subnet.ec2_2_public_subnet.id,
  ]
  target_group_arns = [aws_lb_target_group.target_group_alb.arn]
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress.name
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress.name
}
