variable "application_cluster_lb_security_groups" {
  description = "security-groups which should be assigned to the lb"
  type = "list"
}

variable "application_cluster_lb_access_log_bucket" {
  description = "the bucket name to save the lb-access-logs to. The application-data-bucket of all accounts is configured for log-file-access"
}

variable "application_cluster_lb_access_log_folder" {
  description = "the folder where the logs should be saved. The application-data-bucket of all accounts is configured with the default path"
  default = "logs/access"
}

variable "application_cluster_access_log_enabled" {
  description = "enable/disable the logging of access (default: true)"
  default = true
}

variable "application_cluster_loadbalancer_type" {
  description = "which lb type to use: application or network (default: application)"
  default = "application"
  type = "string"
}

variable "application_cluster_ssl_cert_arn" {
  description = "The ssl-certificate for the lb"
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

variable "application_cluster_subnet_ids" {
  type = "list"
}

variable "application_cluster_vpc_id" {
  description = "vpc to attach target groups to"
  type = "string"
}

variable "application_cluster_ssl_policy" {
  description = "Policy for SSL"
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "application_cluster_additional_certificate_arns" {
  description = "more certificates to add to the listener"
  type = "list"
  default = []
}
