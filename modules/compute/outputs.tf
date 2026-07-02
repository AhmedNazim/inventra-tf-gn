output "frontend_public_ip" {
  description = "IP publique fixe du frontend (via EIP)"
  value       = aws_eip.frontend.public_ip
}

output "backend_private_ip" {
  description = "IP privée du backend (utilisée par le proxy Nginx)"
  value       = aws_instance.backend.private_ip
}

output "frontend_url" {
  description = "URL d'accès à l'application Inventra"
  value       = "http://${aws_eip.frontend.public_ip}/"
}

output "backend_instance_id" {
  description = "ID de l'instance EC2 backend (pour le monitoring)"
  value       = aws_instance.backend.id
}

output "frontend_instance_id" {
  description = "ID de l'instance EC2 frontend (pour le monitoring)"
  value       = aws_instance.frontend.id
}
