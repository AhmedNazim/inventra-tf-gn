#!/bin/bash
set -euo pipefail

dnf update -y
dnf install -y python3 python3-pip

DB_URL=$(aws ssm get-parameter --name "${db_ssm_path}" \
  --with-decryption --query "Parameter.Value" --output text \
  --region "${aws_region}")

mkdir -p /opt/inventra
cd /opt/inventra

aws s3 cp "s3://${app_bucket}/app.py" ./app.py --region "${aws_region}"
aws s3 cp "s3://${app_bucket}/models.py" ./models.py --region "${aws_region}"

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install flask flask-cors flask-sqlalchemy psycopg2-binary gunicorn

mkdir -p /etc/inventra
cat > /etc/inventra/backend.env << ENVEOF
DATABASE_URL=$DB_URL
PORT=5000
ENVEOF
chmod 600 /etc/inventra/backend.env

cat > /etc/systemd/system/inventra-backend.service << SERVICEEOF
[Unit]
Description=Inventra Backend API
After=network.target

[Service]
EnvironmentFile=/etc/inventra/backend.env
WorkingDirectory=/opt/inventra
ExecStart=/opt/inventra/venv/bin/gunicorn --bind 0.0.0.0:5000 --workers 2 app:app
Restart=always

[Install]
WantedBy=multi-user.target
SERVICEEOF

systemctl daemon-reload
systemctl enable --now inventra-backend
