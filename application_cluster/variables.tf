variable "application_cluster_ami_id" {
  description = "the AMI with which the app-servers should be created"
}

variable "application_cluster_instance_type" {
  description = "the size of the instances, e.g. t2.micro"
}

variable "application_cluster_launch_configuration_security_groups" {
  description = "Security-Groups to append to the instances"
  type = "list"
}

variable "application_cluster_launch_configuration_detailed_monitoring" {
  description = "Enable/disable detailed monitoring"
  default = false
}

variable "application_cluster_user_data" {
  description = "Custom start-up script in base64-style"
  default = ""
}

variable "application_cluster_instance_role_id" {
  description = "the instance-role to attach to the appservers"
  default = ""
}

variable "application_cluster_application_name" {
  description = "the name of the application beeing build"
}

variable "application_cluster_environment" {
  description = "the environement of the cluster, e.g. stage or live"
}

variable "application_cluster_instance_port_http" {
  default = 80
  description = "the port for http on the instances"
}

variable "application_cluster_max_size" {
  default = 1
  description = "defines the max-value of the autoscaling group"
}

variable "application_cluster_min_size" {
  default = 1
  description = "defineds the min-value for the autoscaling group"
}

variable "application_cluster_subnet_ids" {
  type = "list"
}

variable "application_cluster_vpc_id" {
  description = "vpc to attach target groups to"
  type = "string"
}

variable "application_cluster_propagate_at_launch" {
  default = true
}

variable "loadbalancer_listener_arn" {
  description = "arn of listener from loadbalancer"
  type = "string"
  default = ""
}

variable "loadbalancer_listener_ssl_arn" {
  description = "arn of ssl listener from loadbalancer"
  type = "string"
  default = ""
}

variable "application_cluster_listener_rule_condition_field" {
  description = "field on which the condition should be triggered"
  type = "string"
  default = ""
}

variable "application_cluster_listener_rule_condition_values" {
  description = "values which should be used on condition"
  type = "list"
  default = []
}

variable application_cluster_target_group_protocol {
  type = "string"
  default = "HTTP"
}

variable "healthcheck_interval" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#interval"
  default = 30
}

variable "healthcheck_path" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#path"
  default = "/"
}

variable "healthcheck_port" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#port-1"
  default = "traffic-port"
}

variable "healthcheck_protocol" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#protocol-1"
  default = "HTTP"
}

variable "healthcheck_timeout" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#timeout"
  default = 5
}

variable "healthcheck_healthy_threshold" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#healthy_threshold"
  default = 3
}

variable "healthcheck_unhealthy_threshold" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#unhealthy_threshold"
  default = 3
}

variable "healthcheck_matcher" {
  description = "see https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#matcher"
  default = "200"
}

variable "root_block_device_volume_type" {
  description = "see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration#block-devices"
  default = "standard"
}

variable "root_block_device_volume_size" {
  description = "see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration#block-devices"
  default = "50"
}

variable "root_block_device_delete_on_termination" {
  description = "see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration#block-devices"
  default = "true"
}

variable "root_block_device_encrypted" {
  description = "see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration#block-devices"
  default = "true"
}
