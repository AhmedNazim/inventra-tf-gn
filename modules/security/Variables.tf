variable "name_prefix" {
  description = "Préfixe utilisé pour nommer toutes les ressources de sécurité"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC dans lequel créer les security groups"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR autorisé à se connecter en SSH aux instances"
  type        = string
}
