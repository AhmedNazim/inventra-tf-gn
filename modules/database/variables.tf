variable "name_prefix" {
  description = "Préfixe utilisé pour nommer les ressources de la base de données"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Nom du DB subnet group (créé par le module networking)"
  type        = string
}

variable "sg_rds_id" {
  description = "ID du security group RDS (créé par le module security)"
  type        = string
}

variable "db_name" {
  description = "Nom de la base de données PostgreSQL"
  type        = string
}

variable "db_username" {
  description = "Nom d'utilisateur PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Mot de passe PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe d'instance RDS"
  type        = string
}
