#!/bin/bash

#docker compose exec db bash -c "apt install mariadb-backup"

docker compose exec db bash -c 'rm -rf /backup/*'
docker compose exec db bash -c '/usr/bin/mariadb-backup --backup --target-dir=/backup --user=root --password=password'

sudo tar -czvf /home/ubuntu/dev/agoraMultiSites/wordpress_backup/wordpress_backup.tar.gz  --exclude=/home/ubuntu/dev/agoraMultiSites/wordpress_files/wp-content/uploads /home/ubuntu/dev/agoraMultiSites/wordpress_files
