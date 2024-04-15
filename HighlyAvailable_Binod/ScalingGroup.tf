resource "aws_launch_configuration" "launch-config" {
  name          = "ec3-launch-config"
  image_id      = "ami-09ccb67fcbf1d625c"
  instance_type = "t2.micro"
  key_name      = "binodkey"
  security_groups = [aws_security_group.scale-sg-group.id]
  associate_public_ip_address = true
  user_data = data.template_file.userdata_script.rendered
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "userdata_script" {
  template = file("${path.module}/install_wordpress.sh.tpl")

  vars = {
    rds_endpoint = aws_db_instance.wordpressdb.endpoint
    db_name          = var.database_name
    db_username      = var.database_username
    db_password      = var.database_password
  }
}

resource "aws_autoscaling_group" "my-auto-scale" {
  name                 = "my-asg"
  launch_configuration = aws_launch_configuration.launch-config.id
  min_size             = 1
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  tag {
    key                 = "AutoScale"
    value               = "wordpress-instance"
    propagate_at_launch = true
  }
 target_group_arns    = [aws_lb_target_group.wordpress_target_group.arn]
}

resource "aws_autoscaling_policy" "scaling-policy" {
  name                   = "my-scaling-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my-auto-scale.name

  metric_aggregation_type = "Average"
  
}
  

