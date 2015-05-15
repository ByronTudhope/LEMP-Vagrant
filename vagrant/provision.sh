#!/bin/bash

DBPASSWD=

echo "Provisioning virtual machine..."
echo "This can take a long time!"

sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

echo "Updating"

apt-get install software-properties-common > /dev/null 2>&1
apt-get update > /dev/null 2>&1

echo "Upgrading"
apt-get upgrade -y > /dev/null 2>&1

echo "Setting default locale"

export LANGUAGE=en_US.UTF-8 > /dev/null
export LANG=en_US.UTF-8 > /dev/null
export LC_ALL=en_US.UTF-8 > /dev/null
locale-gen en_US.UTF-8 > /dev/null
locale-gen UTF-8 > /dev/null
dpkg-reconfigure locales > /dev/null

echo "Setting time zone"

echo "Africa/Johannesburg" | tee /etc/timezone > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1

echo "Installing build-essential"
apt-get install build-essential -y > /dev/null 2>&1

echo "Installing poppler-utils"
apt-get install poppler-utils -y > /dev/null 2>&1

echo "Installing Git"
apt-get install git -y > /dev/null 2>&1
 
echo "Installing Nginx"
service apache2 stop > /dev/null 2>&1
apt-get install nginx -y > /dev/null 2>&1

echo "Installing debconf-utils"
apt-get install debconf-utils -y > /dev/null 2>&1

echo "Preparing to install mysql-server"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

echo "Installing mysql-server"
apt-get install mysql-server-5.5 -y > /dev/null 2>&1

echo "Installing mysql-common"
apt-get install mysql-common -y > /dev/null 2>&1

echo "Installing mysql-client"
apt-get install mysql-client -y > /dev/null 2>&1

echo "Installing CURL"
apt-get install curl -y > /dev/null 2>&1

echo "Installing php5-fpm"
apt-get install php5-fpm -y > /dev/null 2>&1

echo "Installing php5-curl"
apt-get install php5-curl -y > /dev/null 2>&1

echo "Installing php5-cli"
apt-get install php5-cli -y > /dev/null 2>&1

echo "Installing php5-mcrypt"
apt-get install php5-mcrypt -y > /dev/null 2>&1

echo "Installing php5-mysql"
apt-get install php5-mysql -y > /dev/null 2>&1

echo "Installing htop"
apt-get install htop -y > /dev/null 2>&1

echo "Preparing to install phpmyadmin"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"﻿

echo "Installing phpmyadmin"
apt-get -q -y install phpmyadmin > /dev/null 2>&1

echo "Configuring phpmyadmin"

rm -rf /etc/phpmyadmin/config.inc.php
cp /vagrant/phpmyadmin/config.inc.php /etc/phpmyadmin/

echo "Configuring PHP"

apt-get install php-pear > /dev/null 2>&1

rm -rf /etc/php5/fpm/php.ini
cp /vagrant/php5/php.ini /etc/php5/fpm/

rm -rf /etc/php5/fpm/pool.d/www.conf
cp /vagrant/php5/www.conf /etc/php5/fpm/pool.d/

echo "Restarting mysql"
service mysql start > /dev/null 2>&1
service mysql restart > /dev/null 2>&1

echo "Restarting PHP"
php5enmod mcrypt > /dev/null 2>&1
service php5-fpm start > /dev/null 2>&1
service php5-fpm restart > /dev/null 2>&1

echo "Installing Composer"
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer > /dev/null 2>&1

echo "Configuring Nginx"

rm -rf /etc/nginx/sites-available/default
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/nginx.conf

cp /vagrant/nginx/default /etc/nginx/sites-enabled/
cp /vagrant/nginx/default /etc/nginx/sites-available/

rm -rf /etc/nginx/fastcgi_params
cp /vagrant/nginx/fastcgi_params /etc/nginx/
cp /vagrant/nginx/nginx.conf /etc/nginx/

echo "Restarting nginx"
service apache2 stop > /dev/null 2>&1
service nginx restart > /dev/null 2>&1