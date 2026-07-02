output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs des sous-réseaux publics (frontend + backend)"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs des sous-réseaux privés (RDS)"
  value       = aws_subnet.private[*].id
}

output "db_subnet_group_name" {
  description = "Nom du DB subnet group pour RDS"
  value       = aws_db_subnet_group.this.name
}
