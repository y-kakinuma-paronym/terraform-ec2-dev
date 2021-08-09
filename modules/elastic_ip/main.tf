variable "ec2_id" { }
variable "app_name" { }

resource "aws_eip" "eip" {
  instance = var.ec2_id
  vpc = false

  tags = {
    "Name" = "${var.app_name}-eip"
  }
}