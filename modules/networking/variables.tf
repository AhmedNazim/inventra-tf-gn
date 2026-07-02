variable "name_prefix" {
  description = "Préfixe utilisé pour nommer toutes les ressources réseau"
  type        = string
}

variable "vpc_cidr" {
  description = "Plage CIDR du VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs des sous-réseaux publics (frontend + backend)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs des sous-réseaux privés (RDS)"
  type        = list(string)
}

variable "availability_zones" {
  description = "Liste des zones de disponibilité à utiliser (2 minimum)"
  type        = list(string)
}
