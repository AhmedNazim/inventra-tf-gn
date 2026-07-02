data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "./modules/networking"

  name_prefix           = var.project_name
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  availability_zones     = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "security" {
  source = "./modules/security"

  name_prefix      = var.project_name
  vpc_id           = module.networking.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "database" {
  source = "./modules/database"

  name_prefix           = var.project_name
  db_subnet_group_name  = module.networking.db_subnet_group_name
  sg_rds_id              = module.security.sg_rds_id
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_instance_class      = var.db_instance_class
}

module "compute" {
  source = "./modules/compute"

  name_prefix             = var.project_name
  ami_id                   = var.ami_id
  instance_type_frontend   = var.instance_type_frontend
  instance_type_backend    = var.instance_type_backend
  key_pair_name            = var.key_pair_name
  subnet_id_frontend       = module.networking.public_subnet_ids[0]
  subnet_id_backend        = module.networking.public_subnet_ids[1]
  sg_frontend_id           = module.security.sg_frontend_id
  sg_backend_id            = module.security.sg_backend_id
  instance_profile_name    = module.security.ec2_instance_profile_name
  ec2_role_name            = module.security.ec2_role_name
  db_ssm_path              = module.database.db_connection_ssm_path
  aws_region               = var.aws_region

  app_py_path      = "${path.root}/../inventra/backend/app.py"
  models_py_path   = "${path.root}/../inventra/backend/models.py"
  index_html_path  = "${path.root}/../inventra/frontend/index.html"
  style_css_path   = "${path.root}/../inventra/frontend/style.css"
  app_js_path      = "${path.root}/../inventra/frontend/app.js"
}

module "monitoring" {
  source = "./modules/monitoring"

  name_prefix           = var.project_name
  alert_email            = var.alert_email
  backend_instance_id    = module.compute.backend_instance_id
  frontend_instance_id   = module.compute.frontend_instance_id
  db_identifier           = module.database.db_identifier
}