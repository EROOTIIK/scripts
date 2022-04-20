#!/bin/bash

apt install nginx php7.4-fpm php7.4-mysql mariadb-server -y
systemctl start nginx
systemctl enable nginx

mysql -e "UPDATE mysql.global_priv SET priv=json_set(priv, '$.plugin', 'mysql_native_password', '$.authentication_string', PASSWORD('root')) WHERE User='root';"
mysql -e "DELETE FROM mysql.global_priv WHERE User='';"
mysql -e "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -e "FLUSH PRIVILEGES;"

wget "http://www.adminer.org/latest.php" -O "/var/www/html/adminer.php"
wget "https://raw.githubusercontent.com/vrana/adminer/master/designs/dracula/adminer.css" -O /var/www/html/adminer.css

sed -i 's/\(index\.nginx-debian.html\);/\1 index\.\php;/' /etc/nginx/sites-available/default
sed -i '/#.*\.php\$/s/#//' /etc/nginx/sites-available/default
sed -i '/#.*snippets\/fastcgi-php/s/#//' /etc/nginx/sites-available/default
sed -i '/#.*fastcgi_pass unix/s/#//' /etc/nginx/sites-available/default
sed -i '/#.*fastcgi_pass 127/{n;s/#//}' /etc/nginx/sites-available/default

service nginx restart