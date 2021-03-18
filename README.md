# Terraform AWS Application Cluster

## Basic Information

This terraform module consists of two submodules. One for the loadbalancer and
one for the application-cluster.

This separation is useful to be able to have 1 loadbalancer with 1 or more
application-cluster in different code bases!

1. LoadBalancer

Resources for a LoadBalancer (default: ApplicationLoadBalancer) with
    1 Listener for Port 80 (the default action is to redirect to https)
    1 Listener for Port 443 (An AWS-certificate is mandatory for this at the moment)
    1 Default Target Group (needed to define a listener)
    
2. ApplicationCluster

Resources for an auto scaling group application cluster
    + AutoScaling-Group
    + IAM-Instance-Profile
    + LaunchConfiguration
    + TargetGroup
    + 1 Listener rule to attach it to a loadbalancer listener
    + 1 Listener SSL rule to attach it to a loadbalancer ssl listener

## Usage
### Loadbalancer
#### Variables
- `application_cluster_lb_security_groups`: (list) Security groups which should be assigned to the loadbalancer
- `application_cluster_lb_access_log_bucket`: (string) The bucket name to save the lb-access-logs to.  
- `application_cluster_lb_access_log_folder`: (string) The folder where the logs should be saved.
- `application_cluster_access_log_enabled`: (boolean|default:true) Enable/disable the logging of access.
- `application_cluster_loadbalancer_type`: (string|default:application) Which lb type to use: application or network.
- `application_cluster_ssl_cert_arn`: (string) The default ssl-certificate for the loadbalancer.
- `application_cluster_additional_certificate_arns`: (list) Additional certifactes for the loadbalancer.
- `application_cluster_application_name`: (string) The name to identify the loadbalancer.
- `application_cluster_environment`: (string) The environment of the loadbalancer.
- `application_cluster_instance_port_http`: (int|default:80) The port for http communication with an instance.
- `application_cluster_subnet_ids`: (list) Subnet ids to assign to the loadbalancer
- `application_cluster_vpc_id`: (string) VPC to work with.
- `application_cluster_ssl_policy`: (string|default:ELBSecurityPolicy-TLS-1-2-2017-01) Policy to use for SSL.

### Application-Cluster
#### Variables
- `application_cluster_ami_id`: (string) The AMI with which the app-servers should be created.
- `application_cluster_instance_type`: (string) The size of an instance, e.g. t2.micro.
- `application_cluster_launch_configuration_security_groups`: (list) Security groups which should be assigned to an instance.
- `application_cluster_launch_configuration_detailed_monitoring`: (boolean|default:false) You can find information about detailed_monitoring in the [AWS Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch-new.html).
- `application_cluster_user_data`: (string) Custom start-up script in base64-style.
- `application_cluster_instance_role_id`: (string) The instance-role to attach to an instance.
- `application_cluster_application_name`: (string) The name to identify an instance.
- `application_cluster_environment`: (string) The environment of an instance.
- `application_cluster_instance_port_http`: (int|default:80) The port for http communication with an instance.
- `application_cluster_max_size`: (int|default:1) Defines the max-value of the autoscaling group.
- `application_cluster_min_size`: (int|default:1) Defines the min-value of the autoscaling group.
- `application_cluster_subnet_ids`: (list) Subnet ids to assign to an instance.
- `application_cluster_vpc_id`: (string) VPC to work with.
- `application_cluster_propagate_at_launch`: (bool|default:true)
- `loadbalancer_listener_arn`: (string) ARN of a loadbalancer listener to be able to attach a target group.
- `loadbalancer_listener_ssl_arn`: (string) ARN of a loadbalancer ssl listener to be able to attach a target group.
- `application_cluster_listener_rule_condition_field`: (string) Field on which the listener rule condition should be triggered. More in the [AWS Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RuleCondition.html)!
- `application_cluster_listener_rule_condition_values`: (list) Values which should be used on listener rule condition. More in the [AWS Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-listenerrule-conditions.html)


### Using the Module
```hcl-terraform
module "loadbalancer" {
  source = "git::ssh://git@github.com/solutionDrive/terraform-aws-application-cluster.git//loadbalancer"

  application_cluster_lb_security_groups = ["List", "of", "SecurityGroupIDs"]
  application_cluster_lb_access_log_bucket = "bucket-name-for-logging"
  application_cluster_ssl_cert_arn = "${data.aws_acm_certificate.certificate.arn}"
  application_cluster_application_name = "AwesomeLoadbalancer"
  application_cluster_environment = "stage"
  application_cluster_subnet_ids = ["List", "of", "SubnetIds"]
  application_cluster_vpc_id = "your-vpc-id"
}

data "aws_acm_certificate" "certificate" {
  domain   = "your-awsome-domain.tld"
  statuses = ["ISSUED"]
}
```

```hcl-terraform
module "application_cluster" {
  source = "git::ssh://git@github.com/solutionDrive/terraform-aws-application-cluster.git//application_cluster"
 
  application_cluster_ami_id = "${data.aws_ami.appserver.id}"
  application_cluster_instance_type = "t2.micro"
  application_cluster_launch_configuration_security_groups = ["List", "of", "SecurityGroupIDs"]
  application_cluster_user_data = "your-userdata-script-as-string" #can be loaded from a file
  application_cluster_instance_role_id = "RoleIDForInstanceProfile"
  application_cluster_application_name = "AwesomeApplication"
  application_cluster_environment = "stage"
  application_cluster_max_size = 2 # the maximum size of the cluster
  application_cluster_min_size = 1 # the minimum size of the cluster
  application_cluster_subnet_ids = ["List", "of", "SubnetIds"]
  application_cluster_vpc_id = "your-vpc-id"
  loadbalancer_listener_arn = "arn-of-loadbalancer-listener"
  loadbalancer_listener_ssl_arn = "arn-of-loadbalancer-ssl-listener"
  application_cluster_listener_rule_condition_field = "host-header"
  application_cluster_listener_rule_condition_values = ["*.your-awsome-domain.tld"]
}

data "aws_ami" "appserver" {
  most_recent = true
  filter {
    name   = "name"
    values = ["appserver-image"]
  }
}
```
