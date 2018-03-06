# Terraform AWS Application Cluster

## Basic Information

This terraform module can be used to create an application-cluster consisting of
+ ApplicationLoadBalancer
    + 1 Listener for Port 80
    + 1 Listener for Port 443 (An AWS-certificate is mandatory for this at the moment)
+ AutoScaling-Group
+ IAM-Instance-Profile
+ LaunchConfiguration
+ TargetGroup 

## Usage
### Parameters
```hcl-terraform
variable "application_cluster_elb_security_groups" {
  description = "security-groups which should be assigned to the elb"
  type = "list"
}

variable "application_cluster_elb_access_log_bucket" {
  description = "the bucket name to save the elb-access-logs to. The application-data-bucket of all accounts is configured for log-file-access"
}

variable "application_cluster_elb_access_log_folder" {
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

# Appserver - Cluster
variable "application_cluster_ami_id" {
  description = "the AMI with which the app-servers should be created"
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

variable "application_cluster_instance_role_id" {
  description = "the instance-role to attach to the appservers"
  default = ""
}

variable "application_cluster_instance_type" {
  description = "the size of the instances, e.g. t2.micro"
}

variable "application_cluster_max_size" {
  default = 1
  description = "defines the max-value of the autoscaling group"
}
variable "application_cluster_min_size" {
  default = 1
  description = "defineds the min-value for the autoscaling group"
}

variable "application_cluster_propagate_at_launch" {
  default = true
}

variable "application_cluster_security_groups" {
  description = "Security-Groups to append to the instances"
  type = "list"
}

variable "application_cluster_subnet_ids" {
  type = "list"
}

variable "application_cluster_vpc_id" {
  description = "vpc to attach target groups to"
  type = "string"
}

variable "application_cluster_user_data" {
  description = "Custom start-up script in base64-style"
  default = ""
}

variable "application_cluster_ssl_policy" {
  description = "Policy for SSL"
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}
```

### Using the Module
```hcl-terraform
module "application_cluster" {
  source = "git::ssh://git@github.com/solutionDrive/terraform-aws-application-cluster"

  application_cluster_instance_type = "t2.micro"
  application_cluster_elb_security_groups = ["List", "of", "SecurityGroupIDs"]
  application_cluster_ami_id = "${data.aws_ami.appserver.id}"
  application_cluster_application_name = "AwsomeApplication"
  application_cluster_launch_configuration_security_groups = ["List", "of", "SecurityGroupIDs"]
  application_cluster_environment = "stage"
  application_cluster_vpc_id = "your-vpc-id"
  application_cluster_subnet_ids = ["List", "of", "SubnetIds"]
  application_cluster_max_size = 2 # the maximum size of the cluster
  application_cluster_min_size = 1 # the minimum size of the cluster
  application_cluster_ssl_cert_arn = "${data.aws_acm_certificate.certificate.arn}"
  application_cluster_user_data = "your-userdata-script-as-string" #can be loaded from a file
  application_cluster_elb_access_log_bucket = "bucket-name-for-logging"
  application_cluster_instance_role_id = "RoleIDForInstanceProfile"
}

data "aws_acm_certificate" "certificate" {
  domain   = "${var.oms_domain}"
  statuses = ["ISSUED"]
}

data "aws_ami" "appserver" {
  most_recent = true
  filter {
    name   = "name"
    values = ["appserver-image"]
  }
}

```
