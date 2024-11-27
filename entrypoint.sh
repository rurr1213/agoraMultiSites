#!/bin/bash

# Your custom commands here (e.g., create a directory, install a plugin)
echo "Running custom startup script..."
mkdir -p /var/www/html/custom-directory
echo "After creating directory..."
# Add any other command, such as installing plugins via wp-cli

# Start the original WordPress entrypoint
echo "About to start wordpress"
exec docker-entrypoint.sh apache2-foreground