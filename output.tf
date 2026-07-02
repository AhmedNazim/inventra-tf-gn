output "vpc_id" {
  description = "ID du VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs des sous-réseaux publics"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs des sous-réseaux privés"
  value       = module.networking.private_subnet_ids
}

output "db_subnet_group_name" {
  description = "Nom du DB subnet group"
  value       = module.networking.db_subnet_group_name
}

#Security
output "sg_frontend_id" {
  value = module.security.sg_frontend_id
}

output "sg_backend_id" {
  value = module.security.sg_backend_id
}

output "sg_rds_id" {
  value = module.security.sg_rds_id
}

output "ec2_instance_profile_name" {
  value = module.security.ec2_instance_profile_name
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_connection_ssm_path" {
  value = module.database.db_connection_ssm_path
}

# ── Compute ──────────────────────────────────────────────────────────
output "frontend_url" {
  value = module.compute.frontend_url
}

output "backend_private_ip" {
  value = module.compute.backend_private_ip
}

# ── Monitoring ───────────────────────────────────────────────────────
output "sns_topic_arn" {
  value = module.monitoring.sns_topic_arn
}

output "log_group_name" {
  value = module.monitoring.log_group_name
}