resource "aws_iam_instance_profile" "appserver_instance_profile" {
  role = "${var.application_cluster_instance_role_id}"
}
