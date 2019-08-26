###
### EC2 AUTOSCALING
###
resource "aws_launch_configuration" "swarm-manager-launch-config" {
  name_prefix          = "swarm-manager-launch-config"
#########  image_id             = "${lookup(var.amis, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${aws_key_pair.mykey.key_name}"
  security_groups      = ["${aws_security_group.allow-http.id}"]
}

resource "aws_autoscaling_group" "swarm-manager-autoscaling" {
  name                 = "swarm-manager-autoscaling"
#########  vpc_zone_identifier  = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  launch_configuration = "${aws_launch_configuration.swarm-manager-launch-config.name}"
  min_size             = ${var.min_swarm_managers}
  max_size             = ${var.max_swarm_managers}
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  
  tag = {
    key                 = "Name"
    value               = "swarm-manager"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "swarm-manager-cpu-policy-scaleup" {
  name                   = "swarm-manager-cpu-policy-scaleup"
  autoscaling_group_name = "${aws_autoscaling_group.swarm-manager-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "swarm-manager-cpu-alarm-scaleup" {
  alarm_name          = "swarm-manager-cpu-alarm-scaleup"
  alarm_description   = "swarm-manager-cpu-alarm-scaleup"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.swarm-manager-autoscaling.name}"
  }
  
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.swarm-manager-cpu-policy-scaleup.arn}"]
}

resource "aws_autoscaling_policy" "swarm-manager-cpu-policy-scaledown" {
  name                   = "swarm-manager-cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.swarm-manager-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "swarm-manager-cpu-alarm-scaledown" {
  alarm_name          = "swarm-manager-cpu-alarm-scaledown"
  alarm_description   = "swarm-manager-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"
  
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.swarm-manager-autoscaling.name}"
  }
  
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.swarm-manager-cpu-policy-scaledown.arn}"]
}