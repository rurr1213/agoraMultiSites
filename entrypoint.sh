#!/bin/bash

# Your custom commands here (e.g., create a directory, install a plugin)
echo "Running custom startup script..."
mkdir -p /var/www/html/custom-directory

# Add any other command, such as installing plugins via wp-cli
echo "Setup for certbot"
apt update -y
apt install python3 python3-venv libaugeas0 -y
apt-get remove certbot -y
python3 -m venv /opt/certbot/
/opt/certbot/bin/pip install --upgrade pip
/opt/certbot/bin/pip install certbot certbot-apache
ln -s /opt/certbot/bin/certbot /usr/bin/certbot

apt install vim -y
apt install -y iputils-ping

# Setup sites
a2ensite 000-default-le-ssl.conf
a2enmod ssl

# Start the original WordPress entrypoint
echo "About to start wordpress"
exec docker-entrypoint.sh apache2-foreground