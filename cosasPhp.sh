sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install mysql-workbench php5.6 php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml php5.6-intl php5.6-intl php5.6-mbstring  php5.6-cli php5.6-gd php5.6-curl php5.6-sqlite3 php5.6-soap
apt install libapache2-mod-php5.6
a2dismod php7.0
a2enmod php5.6
service apache2 restart

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
composer

sudo apt install mysql-server
sudo mysql_secure_installation
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';"
sudo mysql
