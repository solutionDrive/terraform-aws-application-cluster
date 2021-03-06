resource "aws_launch_configuration" "application_cluster_appserver_launch_configuration" {
  name_prefix = "${substr(var.application_cluster_application_name, 0, min(14,length(var.application_cluster_application_name)))}-${substr(var.application_cluster_environment, 0, min(4, length(var.application_cluster_environment)))}-"
  image_id = "${var.application_cluster_ami_id}"
  instance_type = "${var.application_cluster_instance_type}"
  security_groups = ["${var.application_cluster_launch_configuration_security_groups}"]
  enable_monitoring = "${var.application_cluster_launch_configuration_detailed_monitoring}"
  user_data = "${var.application_cluster_user_data}"
  # Instance Role has to be defined outsite of this role
  iam_instance_profile = "${aws_iam_instance_profile.appserver_instance_profile.id}"
  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "${var.root_block_device_volume_type}"
    volume_size = "${var.root_block_device_volume_size}"
    delete_on_termination = "${var.root_block_device_delete_on_termination}"
    encrypted = "${var.root_block_device_encrypted}"
  }
}

resource "aws_autoscaling_group" "application_cluster_appserver_auto_scaling_group" {
  name     = "${substr(var.application_cluster_application_name, 0, min(14,length(var.application_cluster_application_name)))}-${substr(var.application_cluster_environment, 0, min(4, length(var.application_cluster_environment)))}-asg"
  launch_configuration = "${aws_launch_configuration.application_cluster_appserver_launch_configuration.id}"
  max_size = "${var.application_cluster_max_size}"
  min_size = "${var.application_cluster_min_size}"
  vpc_zone_identifier = ["${var.application_cluster_subnet_ids}"]
  tag {
    key = "Name"
    value = "${substr(var.application_cluster_application_name, 0, min(14,length(var.application_cluster_application_name)))} - ${substr(var.application_cluster_environment, 0, min(4, length(var.application_cluster_environment)))} - ASG"
    propagate_at_launch = "${var.application_cluster_propagate_at_launch}"
  }
}

resource "aws_lb_listener_rule" "application_cluster_listener_rule" {
  count = "${var.loadbalancer_listener_arn != "" ? 1 : 0}"
  listener_arn = "${var.loadbalancer_listener_arn}"

  action {
    target_group_arn = "${aws_lb_target_group.application_cluster_target_group.arn}"
    type             = "forward"
  }

  condition {
    field = "${var.application_cluster_listener_rule_condition_field}"
    values = "${var.application_cluster_listener_rule_condition_values}"
  }
}

resource "aws_lb_listener_rule" "application_cluster_listener_ssl_rule" {
  count = "${var.loadbalancer_listener_ssl_arn != "" ? 1 : 0}"
  listener_arn = "${var.loadbalancer_listener_ssl_arn}"

  action {
    target_group_arn = "${aws_lb_target_group.application_cluster_target_group.arn}"
    type             = "forward"
  }

  condition {
    field = "${var.application_cluster_listener_rule_condition_field}"
    values = "${var.application_cluster_listener_rule_condition_values}"
  }
}

resource "aws_lb_target_group" "application_cluster_target_group" {
  name     = "${substr(var.application_cluster_application_name, 0, min(14,length(var.application_cluster_application_name)))}-${substr(var.application_cluster_environment, 0, min(4, length(var.application_cluster_environment)))}-target-group"
  port     = "${var.application_cluster_instance_port_http}"
  protocol = "${var.application_cluster_target_group_protocol}"
  vpc_id   = "${var.application_cluster_vpc_id}"

  health_check {
    interval = "${var.healthcheck_interval}"
    path = "${var.healthcheck_path}"
    port = "${var.healthcheck_port}"
    protocol = "${var.healthcheck_protocol}"
    timeout = "${var.healthcheck_timeout}"
    healthy_threshold = "${var.healthcheck_healthy_threshold}"
    unhealthy_threshold = "${var.healthcheck_unhealthy_threshold}"
    matcher = "${var.healthcheck_matcher}"
  }
}

resource "aws_autoscaling_attachment" "application_cluster_autoscaling_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.application_cluster_appserver_auto_scaling_group.id}"
  alb_target_group_arn = "${aws_lb_target_group.application_cluster_target_group.arn}"
}
