# EC2 Instances
resource "aws_instance" "app_instances" {
  for_each = var.instances

  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnets[each.value.subnet_index % length(var.public_subnets)]
  vpc_security_group_ids = [var.instance_security_group]
  user_data              = each.value.user_data

}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "default" {
  target_group_arn = var.target_group_arns["default"]
  target_id        = aws_instance.app_instances["default"].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "images" {
  target_group_arn = var.target_group_arns["images"]
  target_id        = aws_instance.app_instances["images"].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "register" {
  target_group_arn = var.target_group_arns["register"]
  target_id        = aws_instance.app_instances["register"].id
  port             = 80
}