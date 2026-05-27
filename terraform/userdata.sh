#!/bin/bash
yum update -y
yum install -y docker stress-ng
systemctl enable docker
systemctl start docker

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

mkdir -p /opt/site
cat > /opt/site/index.html <<EOF
<h1>Welcome to My Scalable Site</h1>
<p>Served by Nginx on Docker</p>
<p><b>Instance:</b> $INSTANCE_ID</p>
EOF

docker run -d -p 80:80 -v /opt/site:/usr/share/nginx/html:ro --restart always --name web nginx:alpine
