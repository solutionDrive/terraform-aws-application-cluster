resource "aws_lb" "application_cluster_loadbalancer" {
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

resource "aws_lb_target_group" "application_cluster_target_group" {
  name     = "${var.application_cluster_application_name}-${var.application_cluster_environment}-target-group"
  port     = "${var.application_cluster_instance_port_http}"
  protocol = "HTTP"
  vpc_id   = "${var.application_cluster_vpc_id}"
}

resource "aws_autoscaling_attachment" "application_cluster_autoscaling_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.application_cluster_appserver_auto_scaling_group.id}"
  alb_target_group_arn = "${aws_lb_target_group.application_cluster_target_group.arn}"
}

resource "aws_lb_listener" "application_cluster_listener" {
  load_balancer_arn = "${aws_lb.application_cluster_loadbalancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.application_cluster_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "application_cluster_listener_ssl" {
  load_balancer_arn = "${aws_lb.application_cluster_loadbalancer.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.application_cluster_ssl_policy}"
  certificate_arn   = "${var.application_cluster_ssl_cert_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.application_cluster_target_group.arn}"
    type             = "forward"
  }
}
