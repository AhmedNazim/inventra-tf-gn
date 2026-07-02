output "db_endpoint" {
  description = "Endpoint (hostname) de l'instance RDS"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port d'écoute PostgreSQL"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Nom de la base de données"
  value       = aws_db_instance.this.db_name
}

output "db_connection_ssm_path" {
  description = "Path du paramètre SSM contenant l'URL de connexion complète"
  value       = aws_ssm_parameter.db_url.name
}

output "db_identifier" {
  description = "Identifiant de l'instance RDS (pour cibler les alarmes CloudWatch)"
  value       = aws_db_instance.this.identifier
}