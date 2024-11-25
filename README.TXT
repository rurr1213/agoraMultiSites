To start the docker containers type

docker compose up
	this will use the docker.yaml file to start both db (maria db) and wordpress. wordpress is configured already to use
	multisite by adding specific fields into vi /var/www/html/wp-config.php
	
docker compose down
	this will shutdown to setup

docker ps
	to show whats up if any

See docker help for more info on how to use and or ask gemini

to get into container type

	docker exec -it <name of container> bash

The wordpress site can be accessed at primary.hyperkube.net
	user: ravi
	pwd: Bfrx100#


