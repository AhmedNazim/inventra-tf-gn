#!/bin/bash
set -euo pipefail

dnf update -y
dnf install -y nginx

mkdir -p /usr/share/nginx/html

aws s3 cp "s3://${app_bucket}/index.html" /usr/share/nginx/html/index.html --region "${aws_region}"
aws s3 cp "s3://${app_bucket}/style.css" /usr/share/nginx/html/style.css --region "${aws_region}"
aws s3 cp "s3://${app_bucket}/app.js" /usr/share/nginx/html/app.js --region "${aws_region}"

# Injecte window.INVENTRA_API_URL = '' pour que le navigateur appelle
# /api/* sur le même host (proxy_pass Nginx)
sed -i 's#<script src="app.js"></script>#<script>window.INVENTRA_API_URL = "";</script>\n  <script src="app.js"></script>#' /usr/share/nginx/html/index.html

cat > /etc/nginx/conf.d/inventra.conf << NGINXEOF
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://${backend_private_ip}:5000/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /health {
        proxy_pass http://${backend_private_ip}:5000/health;
    }
}
NGINXEOF

rm -f /etc/nginx/conf.d/default.conf 2>/dev/null || true

systemctl enable --now nginx
systemctl restart nginx
