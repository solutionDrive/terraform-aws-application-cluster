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
  value = "${aws_lb_listener.loadbalancer_listener.id}"
}

output "loadbalancer_listener_arn" {
  value = "${aws_lb_listener.loadbalancer_listener.arn}"
}

output "loadbalancer_listener_ssl_id" {
  value = "${aws_lb_listener.loadbalancer_listener_ssl.id}"
}

output "loadbalancer_listener_ssl_arn" {
  value = "${aws_lb_listener.loadbalancer_listener_ssl.arn}"
}

output "loadbalancer_default_target_group_id" {
  value = "${aws_lb_target_group.loadbalancer_default_target_group.id}"
}

output "loadbalancer_default_target_group_arn" {
  value = "${aws_lb_target_group.loadbalancer_default_target_group.arn}"
}

output "loadbalancer_default_target_group_vpc_id" {
  value = "${aws_lb_target_group.loadbalancer_default_target_group.vpc_id}"
}
