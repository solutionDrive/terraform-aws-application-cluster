output "application_cluster_loadbalancer_id" {
  value = "${aws_lb.application_cluster_loadbalancer.id}"
}

output "application_cluster_loadbalancer_dns" {
  value = "${aws_lb.application_cluster_loadbalancer.dns_name}"
}

output "application_cluster_loadbalancer_zone_id" {
  value = "${aws_lb.application_cluster_loadbalancer.zone_id}"
}
