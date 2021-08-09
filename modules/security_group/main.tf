variable "app_name" { }
variable "vpc_id" { }

# セキュリティグループ
resource "aws_security_group" "security_group" {
  name = "terraform-example-sg"
  vpc_id = var.vpc_id
  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  lifecycle {
    # 何らかの変更を実行した際に、既存のインスタンスを破棄する
    create_before_destroy = true
  }

  tags = {
    "Name" = "${var.app_name}-sg"
  }
}