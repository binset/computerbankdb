DBHOST=localhost
DBNAME=vtiger
DBUSER=vtiger
DBPASSWD=examplepassword_notactuallyreal

echo "mysql-server mysql-server/root_password password $DBPASSWD"       | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true"              | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"    | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"        | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"          | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"     | sudo debconf-set-selections

#sudo apt-get update
sudo apt-get install -y zsh vim screen 
sudo apt-get install -y vim curl python-software-properties
sudo apt-get install -y binutils  ncftp nmap 
sudo apt-get install -y mysql-server-5.5 git-core 
sudo apt-get install -y apache2 
sudo apt-get install -y php5 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-readline php5-mysql php5-xdebug
sudo apt-get install -y curl libcurl3 libcurl3-dev php5-curl php5-imap
sudo apt-get install -y phpmyadmin

sudo php5enmod imap
sudo a2enmod rewrite
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sudo sed -i "s/max_execution_time = .*/max_execution_time = 600/" /etc/php5/apache2/php.ini
sudo sed -i "s/error_reporting = .*/error_reporting = E_WARNING & ~E_NOTICE & ~E_DEPRECATED & ~E_STRICT/" /etc/php5/apache2/php.ini
sudo sed -i "s/log_errors = .*/log_errors = Off/" /etc/php5/apache2/php.ini
sudo sed -i "s/short_open_tag = .*/short_open_tag = On/" /etc/php5/apache2/php.ini
sudo service apache2 restart

cd /var/tmp/
wget --no-verbose http://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%206.3.0/Core%20Product/vtigercrm6.3.0.tar.gz
cd /var/www/html
sudo tar -xzf /var/tmp/vtigercrm6.3.0.tar.gz
sudo mv vtigercrm database
sudo chown -R www-data:www-data database
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY


sudo mysql -u root -p$DBPASSWD -e "create user '$DBUSER'@'localhost' identified by '$DBPASSWD';"
sudo mysql -u root -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"
sudo mysql -u root -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
sudo mysql -u root -p$DBPASSWD -e "FLUSH PRIVILEGES;"
