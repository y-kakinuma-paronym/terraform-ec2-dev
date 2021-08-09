output "ip" {
  description = "Elastic IP Adrress"
  value = aws_eip.eip.public_ip
}