output "auto_scaling_group_id" {
  value = "${aws_autoscaling_group.application_cluster_appserver_auto_scaling_group.id}"
}

output "auto_scaling_group_arn" {
  value = "${aws_autoscaling_group.application_cluster_appserver_auto_scaling_group.arn}"
}

output "auto_scaling_group_name" {
  value = "${aws_autoscaling_group.application_cluster_appserver_auto_scaling_group.name}"
}

output "launch_configuration_id" {
  value = "${aws_launch_configuration.application_cluster_appserver_launch_configuration.id}"
}

output "launch_configuration_name" {
  value = "${aws_launch_configuration.application_cluster_appserver_launch_configuration.name}"
}

output "target_group_id" {
  value = "${aws_lb_target_group.application_cluster_target_group.id}"
}

output "target_group_arn" {
  value = "${aws_lb_target_group.application_cluster_target_group.arn}"
}

output "target_group_name" {
  value = "${aws_lb_target_group.application_cluster_target_group.name}"
}
