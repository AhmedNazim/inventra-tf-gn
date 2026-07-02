variable "name_prefix" {
  description = "Préfixe utilisé pour nommer les ressources compute"
  type        = string
}

variable "ami_id" {
  description = "AMI Amazon Linux 2023"
  type        = string
}

variable "instance_type_frontend" {
  description = "Type d'instance EC2 pour le frontend"
  type        = string
}

variable "instance_type_backend" {
  description = "Type d'instance EC2 pour le backend"
  type        = string
}

variable "key_pair_name" {
  description = "Nom de la paire de clés SSH"
  type        = string
}

variable "subnet_id_frontend" {
  description = "ID du subnet public pour le frontend"
  type        = string
}

variable "subnet_id_backend" {
  description = "ID du subnet public pour le backend"
  type        = string
}

variable "sg_frontend_id" {
  description = "ID du security group frontend"
  type        = string
}

variable "sg_backend_id" {
  description = "ID du security group backend"
  type        = string
}

variable "instance_profile_name" {
  description = "Nom de l'instance profile IAM à attacher aux EC2"
  type        = string
}

variable "ec2_role_name" {
  description = "Nom du rôle IAM EC2 (pour y attacher la policy de lecture S3)"
  type        = string
}

variable "db_ssm_path" {
  description = "Path SSM du paramètre contenant l'URL de connexion DB"
  type        = string
}

variable "aws_region" {
  description = "Région AWS (pour les appels SSM dans user_data)"
  type        = string
}

variable "app_py_path" {
  description = "Chemin local vers le fichier app.py de l'application"
  type        = string
}

variable "models_py_path" {
  description = "Chemin local vers le fichier models.py de l'application"
  type        = string
}

variable "index_html_path" {
  description = "Chemin local vers index.html du frontend"
  type        = string
}

variable "style_css_path" {
  description = "Chemin local vers style.css du frontend"
  type        = string
}

variable "app_js_path" {
  description = "Chemin local vers app.js du frontend"
  type        = string
}
