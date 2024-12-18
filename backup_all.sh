#!/bin/bash

#docker compose exec db bash -c "apt install mariadb-backup"

docker compose exec db bash -c 'rm -rf /backup/*'
docker compose exec db bash -c '/usr/bin/mariadb-backup --backup --target-dir=/backup --user=root --password=password'
docker compose exec db bash -c 'tar -czvf /backup/db_backup_archive.tar.gz --mode=a+r /backup/*'
docker compose cp db:/backup/db_backup_archive.tar.gz db_backup/db_backup_archive.tar.gz


sudo tar -czvf /home/ubuntu/dev/agoraMultiSites/wordpress_backup/wordpress_backup.tar.gz  --exclude=/home/ubuntu/dev/agoraMultiSites/wordpress_files/wp-content/uploads /home/ubuntu/dev/agoraMultiSites/wordpress_files
