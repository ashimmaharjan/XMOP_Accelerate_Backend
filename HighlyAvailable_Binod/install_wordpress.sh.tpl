#!/bin/bash

set -x

export RDS_ENDPOINT="${rds_endpoint}"


# Update the system and install necessary packages
sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum install -y ${apache_version} php ${db_type}

# Install Latest PHP
sudo yum install -y https://amazonlinux.extras.amazonaws.com/epel/7/x86_64/Packages/o/oniguruma-6.8.2-1.amzn2.0.2.x86_64.rpm
sudo amazon-linux-extras enable ${php_version}
sudo yum install -y php

# Install and enable PHP MySQLi extension
sudo yum install -y php-mysqli

# Start and enable Apache
sudo systemctl start ${apache_version}
sudo systemctl enable ${apache_version}

# Install WordPress Dependencies
sudo yum install -y wget

# Download and Install WordPress
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo chown -R apache:apache wordpress

# Set permissions
sudo chown -R www-data:www-data wordpress
sudo find wordpress/ -type d -exec chmod 755 {} \;
sudo find wordpress/ -type f -exec chmod 644 {} \;


# Configure WordPress
cd wordpress
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/${db_name}/" wp-config.php
sudo sed -i "s/username_here/${db_username}/" wp-config.php
sudo sed -i "s/password_here/${db_password}/" wp-config.php
sudo sed -i "s/localhost/$RDS_ENDPOINT/" wp-config.php

# Configure Apache VirtualHost
sudo tee /etc/httpd/conf.d/wordpress.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /var/www/html/wordpress
    ServerName _default_
    <Directory /var/www/html/wordpress>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Clean Up
sudo rm -f /var/www/html/latest.tar.gz

# Restart Apache
sudo systemctl restart httpd
