data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_s3_bucket" "app" {
  bucket        = "${var.name_prefix}-app-deploy"
  force_destroy = true

  tags = {
    Name = "${var.name_prefix}-app-deploy"
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket                  = aws_s3_bucket.app.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "app_py" {
  bucket = aws_s3_bucket.app.id
  key    = "app.py"
  source = var.app_py_path
  etag   = filemd5(var.app_py_path)
}

resource "aws_s3_object" "models_py" {
  bucket = aws_s3_bucket.app.id
  key    = "models.py"
  source = var.models_py_path
  etag   = filemd5(var.models_py_path)
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.app.id
  key    = "index.html"
  source = var.index_html_path
  etag   = filemd5(var.index_html_path)
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.app.id
  key    = "style.css"
  source = var.style_css_path
  etag   = filemd5(var.style_css_path)
}

resource "aws_s3_object" "app_js" {
  bucket = aws_s3_bucket.app.id
  key    = "app.js"
  source = var.app_js_path
  etag   = filemd5(var.app_js_path)
}

resource "aws_iam_role_policy" "app_bucket_read" {
  name = "${var.name_prefix}-app-bucket-read"
  role = var.ec2_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.app.arn}/*"
      }
    ]
  })
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ssm_parameter.al2023_ami.value
  instance_type          = var.instance_type_backend
  subnet_id              = var.subnet_id_backend
  vpc_security_group_ids = [var.sg_backend_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = var.instance_profile_name

  user_data = base64encode(templatefile("${path.module}/user_data_backend.sh.tpl", {
    db_ssm_path = var.db_ssm_path
    aws_region  = var.aws_region
    app_bucket  = aws_s3_bucket.app.id
  }))

  tags = {
    Name = "${var.name_prefix}-backend"
  }

  depends_on = [
    aws_s3_object.app_py,
    aws_s3_object.models_py,
    aws_iam_role_policy.app_bucket_read,
  ]
}

resource "aws_instance" "frontend" {
  ami                    = data.aws_ssm_parameter.al2023_ami.value
  instance_type          = var.instance_type_frontend
  subnet_id              = var.subnet_id_frontend
  vpc_security_group_ids = [var.sg_frontend_id]
  key_name               = var.key_pair_name
  iam_instance_profile   = var.instance_profile_name

  user_data = base64encode(templatefile("${path.module}/user_data_frontend.sh.tpl", {
    backend_private_ip = aws_instance.backend.private_ip
    aws_region          = var.aws_region
    app_bucket          = aws_s3_bucket.app.id
  }))

  tags = {
    Name = "${var.name_prefix}-frontend"
  }

  depends_on = [
    aws_instance.backend,
    aws_s3_object.index_html,
    aws_s3_object.style_css,
    aws_s3_object.app_js,
    aws_iam_role_policy.app_bucket_read,
  ]
}

resource "aws_eip" "frontend" {
  instance = aws_instance.frontend.id
  domain   = "vpc"

  tags = {
    Name = "${var.name_prefix}-frontend-eip"
  }
}
