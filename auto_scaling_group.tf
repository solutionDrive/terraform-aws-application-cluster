resource "aws_launch_configuration" "application_cluster_appserver_launch_configuration" {
  image_id = "${var.application_cluster_ami_id}"
  instance_type = "${var.application_cluster_instance_type}"
  security_groups = ["${var.application_cluster_security_groups}"]
  user_data = "${var.application_cluster_user_data}"
  # Instance Role has to be defined outsite of this role
  iam_instance_profile = "${var.application_cluster_instance_role_id}"
  lifecycle {
    create_before_destroy = "${var.application_cluster_create_before_destroy}"
  }
}

resource "aws_autoscaling_group" "application_cluster_appserver_auto_scaling_group" {
  name     = "${var.application_cluster_application_name}-${var.application_cluster_environment}-asg"
  launch_configuration = "${aws_launch_configuration.application_cluster_appserver_launch_configuration.id}"
  max_size = "${var.application_cluster_max_size}"
  min_size = "${var.application_cluster_min_size}"
  vpc_zone_identifier = ["${var.application_cluster_subnet_ids}"]
  tag {
    key = "Name"
    value = "ASG - ${var.application_cluster_application_name} - ${var.application_cluster_environment}"
    propagate_at_launch = "${var.application_cluster_propagate_at_launch}"
  }
}