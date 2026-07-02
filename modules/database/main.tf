# ── Instance RDS PostgreSQL ──────────────────────────────────────────
resource "aws_db_instance" "this" {
  identifier     = "${var.name_prefix}-db"
  engine         = "postgres"
  engine_version = "15"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.sg_rds_id]

  multi_az                 = false
  skip_final_snapshot      = true
  backup_retention_period  = 1
  publicly_accessible      = false

  tags = {
    Name = "${var.name_prefix}-db"
  }
}

# ── Paramètre SSM SecureString : URL de connexion complète ─────────
# Jamais le mot de passe seul en clair dans les outputs — uniquement
# le path SSM est exposé (voir outputs.tf).
resource "aws_ssm_parameter" "db_url" {
  name        = "/${var.name_prefix}/db_url"
  description = "URL de connexion PostgreSQL complete pour le backend Inventra"
  type        = "SecureString"
  value       = "postgresql://${urlencode(var.db_username)}:${urlencode(var.db_password)}@${aws_db_instance.this.endpoint}/${var.db_name}"

  tags = {
    Name = "${var.name_prefix}-db-url"
  }
}
