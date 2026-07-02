variable "name_prefix" {
  description = "Préfixe utilisé pour nommer les ressources de monitoring"
  type        = string
}

variable "alert_email" {
  description = "Adresse e-mail destinataire des alertes CloudWatch"
  type        = string
}

variable "backend_instance_id" {
  description = "ID de l'instance EC2 backend"
  type        = string
}

variable "frontend_instance_id" {
  description = "ID de l'instance EC2 frontend"
  type        = string
}

variable "db_identifier" {
  description = "Identifiant de l'instance RDS"
  type        = string
}
