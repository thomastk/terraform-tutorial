#!/bin/bash

yum install httpd24 php56 mysql55-server php56-mysqlnd sendmail -y
service mysqld start
mysql  -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wp_pass'"
mysql  -e "CREATE DATABASE wordpress CHARACTER SET utf8 COLLATE utf8_general_ci"
mysql  -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost'"
mysql  -e "FLUSH PRIVILEGES"

curl https://wordpress.org/latest.tar.gz -o /var/www/wordpress.gz
cd /var/www
tar xzf wordpress.gz
cd wordpress
mv wp-config-sample.php wp-config.php

sed -i -e "s/define('DB_NAME',.*/define('DB_NAME', 'wordpress');/" wp-config.php
sed -i -e "s/define('DB_USER',.*/define('DB_USER', 'wordpress');/" wp-config.php
sed -i -e "s/define('DB_PASSWORD',.*/define('DB_PASSWORD', 'wp_pass');/" wp-config.php

chown -R apache:apache /var/www/wordpress

sed -i 's/\/var\/www\/html/\/var\/www\/wordpress/' /etc/httpd/conf/httpd.conf
service httpd restart
