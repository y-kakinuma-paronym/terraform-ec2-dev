output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# output "public_subnets" {
#   description = "List of IDs of public subnets"
#   value       = module.vpc.public_subnets
# }

output "ip" {
  description = "Elastic IP Adrress"
  value       = module.eip.ip
}