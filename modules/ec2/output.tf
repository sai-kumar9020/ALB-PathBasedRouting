
output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = { for k, v in aws_instance.app_instances : k => v.id }
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = { for k, v in aws_instance.app_instances : k => v.private_ip }
}