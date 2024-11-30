AGORA MULTISITE README
======================
See following contents for refence.

TO USE THIS REPO
================
Created a agoraMultiSites directory
Install docker and docker compose tools
Pull from https://github.com/rurr1213/agoraMultiSites/blob/master/README.TXT
Run docker compose up -d

Everything is defined in compose.yaml and entrypoint.sh, see these for exact operation.

TO ADD NEW SITE STEPS
=====================

*) Add A record to DNS Server
*) Create a new site in wordpress MySites->Network Admin->Sites->Add New Sites
*) Update site wordpress MySites->Network Admin->Sites select site -> Edit->Site Address Set to <domain.com>
3) Add new site domain alias to agoraMultiSites/apache2_sites/available/000-default-le-ssl.conf.
4) Update Certbot certificate to certify existing sites + newsite
5) Restart all, by doing a compose down and compose up -all
6) Go to <new site.com>/wp-admin/ user ravi:Bfrx100#


To start the docker containers type.
------------------------------------

From the agoraMultiSites directory. These will read compose.yaml by default.
compose.yaml defines entrypoint.sh, to be executed in the wordpress container,
to setup stuff, before starting wordpress and apache2. This can take up to 2-3 minutes to finish.
All data files are in
mysql_data and wordpress_files

docker compose up -d
docker compose down
docker image list
docker container list
docker ps
docker ps -a
docker compose logs wordpress
docker compose logs db

docker compose help
docker help


To get into wordpress shell

docker exec -it agoramultisites-wordpress-1 bash

The wordpress site can be accessed at hyperkube.net
	user: ravi
	pwd: Bfrx100#


To setup wordpress multisite
-----------------------------

/var/www/html/wp-config.php and the following line
wp-config.php: Open the wp-config.php file and add the following line before the /* That's all, stop editing! Happy blogging. */ line:

define( 'WP_ALLOW_MULTISITE', true );

Note var/www/html is mapped to the host wordpress_files dir. So this file can be edited here.

The open wordpress at primary.hyperkube.net and go to Tools->Network setup to do sub-directories

It will then show more info to add to files wp-config.php and .htaccess in the same directory. Follow instructions. It may be different from the following:


Add the following to your wp-config.php file in /var/www/html/ above the line reading /* That’s all, stop editing! Happy publishing. */:

define( 'MULTISITE', true );
define( 'SUBDOMAIN_INSTALL', false );
define( 'DOMAIN_CURRENT_SITE', 'primary.hyperkube.net' );
define( 'PATH_CURRENT_SITE', '/' );
define( 'SITE_ID_CURRENT_SITE', 1 );
define( 'BLOG_ID_CURRENT_SITE', 1 );

Add the following to your .htaccess file in /var/www/html/, replacing other WordPress rules:

RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]

# add a trailing slash to /wp-admin
RewriteRule ^([_0-9a-zA-Z-]+/)?wp-admin$ $1wp-admin/ [R=301,L]

RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(wp-(content|admin|includes).*) $2 [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(.*\.php)$ $2 [L]
RewriteRule . index.php [L]

To use wordpress multisite
--------------------------

ON DNS Server, and an A record to point to this IP address
a	@	18.119.99.233	600 seconds

On wordpress Network admin
--------------------------

create new site. Give it default name etc.

Then under sites, select site->Edit and change home name to domain name. <domain.com>

Certbot website certification in wordpress container
----------------------------------------------------
For reference see https://letsencrypt.org/ and https://certbot.eff.org/instructions?ws=apache&os=pip

entrypoint.sh already installed certbot pre requisistes. So just ran

certbot --apache

Certificate is saved at: 	/etc/letsencrypt/live/primary.hyperkube.net/fullchain.pem
Key is saved at:         		/etc/letsencrypt/live/primary.hyperkube.net/privkey.pem
This certificate expires on 2025-02-25.

Successfully deployed certificate for primary.hyperkube.net to /etc/apache2/sites-available/000-default-le-ssl.conf
Successfully deployed certificate for atlas22.net to /etc/apache2/sites-available/000-default-le-ssl.conf
Successfully deployed certificate for atlas22.ai to /etc/apache2/sites-available/000-default-le-ssl.conf
Successfully deployed certificate for atlas22.com to /etc/apache2/sites-available/000-default-le-ssl.conf
Successfully deployed certificate for hyperkube.net to /etc/apache2/sites-available/000-default-le-ssl.

certbot certificates
Saving debug log to /var/log/letsencrypt/letsencrypt.log

Review Certbot certificates
---------------------------

certbot certificates
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Found the following certs:
  Certificate Name: primary.hyperkube.net
    Serial Number: 34e3094c6460ced5d55ee125848063eaf7d
    Key Type: ECDSA
    Domains: primary.hyperkube.net atlas22.ai atlas22.com atlas22.net hyperkube.net
    Expiry Date: 2025-02-25 02:29:45+00:00 (VALID: 87 days)
    Certificate Path: /etc/letsencrypt/live/primary.hyperkube.net/fullchain.pem
    Private Key Path: /etc/letsencrypt/live/primary.hyperkube.net/privkey.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Certificate renewal
-------------------

See section in entrypoints.sh for how it was setup and how to check last renew status.
Do following to see last renew status:
cat /var/log/letsencrypt/letsencrypt.log

crontab setup for automatic renewal.
crontab -l


