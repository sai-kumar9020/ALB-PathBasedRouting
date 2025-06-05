output "alb_security_group_id" {
  description = "ID of the security group for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "instance_security_group_id" {
  description = "ID of the security group for the EC2 instances"
  value       = aws_security_group.ec2_sg.id
}