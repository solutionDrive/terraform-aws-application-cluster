resource "aws_lb" "loadbalancer" {
  access_logs {
    bucket = "${var.application_cluster_lb_access_log_bucket}"
    prefix = "${var.application_cluster_lb_access_log_folder}/${var.application_cluster_environment}"
    enabled = "${var.application_cluster_access_log_enabled}"
  }

  security_groups    = ["${var.application_cluster_lb_security_groups}"]
  subnets            = ["${var.application_cluster_subnet_ids}"]
  name               = "${var.application_cluster_application_name}-${var.application_cluster_environment}"
  load_balancer_type = "${var.application_cluster_loadbalancer_type}"

  enable_deletion_protection = true

  tags {
    Environment = "${var.application_cluster_environment}"
  }
}

resource "aws_lb_listener" "loadbalancer_listener" {
  load_balancer_arn = "${aws_lb.loadbalancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.loadbalancer_default_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "loadbalancer_listener_ssl" {
  load_balancer_arn = "${aws_lb.loadbalancer.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.application_cluster_ssl_policy}"
  certificate_arn   = "${var.application_cluster_ssl_cert_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.loadbalancer_default_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "loadbalancer_default_target_group" {
  name     = "DEFAULT-${substr(var.application_cluster_application_name, 0, min(16,length(var.application_cluster_application_name)))}-${substr(var.application_cluster_environment, 0, min(4, length(var.application_cluster_environment)))}-tg"
  port     = "${var.application_cluster_instance_port_http}"
  protocol = "HTTP"
  vpc_id   = "${var.application_cluster_vpc_id}"
}
