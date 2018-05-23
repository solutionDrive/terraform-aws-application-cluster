output "loadbalancer_id" {
  value = "${aws_lb.loadbalancer.id}"
}

output "loadbalancer_arn" {
  value = "${aws_lb.loadbalancer.arn}"
}

output "loadbalancer_dns_name" {
  value = "${aws_lb.loadbalancer.dns_name}"
}

output "loadbalancer_zone_id" {
  value = "${aws_lb.loadbalancer.zone_id}"
}

output "loadbalancer_listener_id" {
  value = "${
    var.application_cluster_loadbalancer_type == "application" ?
    join(" - ", aws_lb_listener.loadbalancer_listener.*.id) :
    "no-value"
  }"
}

output "loadbalancer_listener_arn" {
  value = "${
    var.application_cluster_loadbalancer_type == "application" ?
    join(" - ", aws_lb_listener.loadbalancer_listener.*.arn) :
    "no-value"
  }"
}

output "loadbalancer_listener_ssl_id" {
  value = "${
    var.application_cluster_loadbalancer_type == "application" ?
    join(" - ", aws_lb_listener.loadbalancer_listener_ssl.*.id) :
    "no-value"
  }"
}

output "loadbalancer_listener_ssl_arn" {
  value = "${
    var.application_cluster_loadbalancer_type == "application" ?
    join(" - ", aws_lb_listener.loadbalancer_listener_ssl.*.arn) :
    "no-value"
  }"
}

output "loadbalancer_default_target_group_id" {
  value = "${var.application_cluster_loadbalancer_type == "application" ?
    join(" - ", aws_lb_target_group.loadbalancer_default_target_group.*.id)
    : "no-value"
  }"
}

output "loadbalancer_default_target_group_arn" {
  value = "${
    var.application_cluster_loadbalancer_type == "application" ?
    join(" - ", aws_lb_target_group.loadbalancer_default_target_group.*.arn) :
    "no-value"
  }"
}

output "loadbalancer_default_target_group_vpc_id" {
  value = "${
    var.application_cluster_loadbalancer_type == "application" ?
    join(" - ", aws_lb_target_group.loadbalancer_default_target_group.*.vpc_id) :
    "no-value"
  }"
}
