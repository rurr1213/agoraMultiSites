#!/bin/bash

# Your custom commands here (e.g., create a directory, install a plugin)
echo "Running custom startup script..."

#--------------------------------------------------
# Add setup for certbot
echo "Setup for certbot"
apt update -y
apt install python3 python3-venv libaugeas0 -y
apt-get remove certbot -y
python3 -m venv /opt/certbot/
/opt/certbot/bin/pip install --upgrade pip
/opt/certbot/bin/pip install certbot certbot-apache
ln -s /opt/certbot/bin/certbot /usr/bin/certbot
apt install cron -y

# Start the cron service
if ! service cron status > /dev/null ; then
    echo "Cron is not running. Starting cron..."
    service cron start
fi

# set up cerbot renew certificates
echo "renew certificates - will only do so if times up"
/opt/certbot/bin/certbot renew

# setup crontab to renew peridically, every day at 0 and 12 hours
# crontab -l # to see whats scheduled
# cat /var/log/cron.log   # to see whats in the log
# cat /var/log/letsencrypt/letsencrypt.log  # to see letsencrypt log - last result
(crontab -l 2>/dev/null; echo "0 0,12 * * * /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && /opt/certbot/bin/certbot renew >>  /var/log/cron.log 2>&1") | crontab -

#--------------------------------------------------
# Add some tools
apt install vim -y
apt install -y iputils-ping

#--------------------------------------------------
# apach2 setup
# Setup sites
a2ensite 000-default-le-ssl.conf
a2ensite 000-default.conf
a2enmod ssl

# Start the original WordPress entrypoint
echo "About to start wordpress"
exec docker-entrypoint.sh apache2-foreground