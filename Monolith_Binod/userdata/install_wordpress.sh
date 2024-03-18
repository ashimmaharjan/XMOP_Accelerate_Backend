#!/bin/bash

set -x

# Update the system and install necessary packages
sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum install -y httpd php mariadb-server

# Install Latest PHP
sudo yum install -y https://amazonlinux.extras.amazonaws.com/epel/7/x86_64/Packages/o/oniguruma-6.8.2-1.amzn2.0.2.x86_64.rpm
sudo amazon-linux-extras enable php8.0
sudo yum install -y php

# Install and enable PHP MySQLi extension
sudo yum install -y php-mysqli

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB Installation (automated)
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('your_password') WHERE User = 'wordpress_user';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create WordPress database and user
sudo mysql -e "CREATE DATABASE wordpress_db;"
sudo mysql -e "CREATE USER 'wordpress_user'@'%' IDENTIFIED BY 'your_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install WordPress Dependencies
sudo yum install -y wget

# Download and Install WordPress
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo chown -R apache:apache wordpress

# Configure WordPress
cd wordpress
sudo cp wp-config-sample.php wp-config.php
sudo sed -i 's/database_name_here/wordpress_db/' wp-config.php
sudo sed -i 's/username_here/wordpress_user/' wp-config.php
sudo sed -i 's/password_here/your_password/' wp-config.php

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
