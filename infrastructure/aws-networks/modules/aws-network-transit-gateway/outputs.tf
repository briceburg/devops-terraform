output "arn" {
  value = aws_ec2_transit_gateway.this.arn
}

output "egress" {
  value = var.network.egress
}

output "id" {
  value = aws_ec2_transit_gateway.this.id
}

output "network_id" {
  value = var.network.id
}




