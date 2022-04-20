#!/bin/bash

echo "Spécifiez un nom pour votre site WordPress :"
read nom

while [[ ! ${nom} =~ ^[0-9,a-z,A-Z,_]+$ ]]
do
    echo "Syntaxe non valide pour ${nom}"
    echo "Spécifiez un nom pour votre site WordPress :"
	read nom
done

./nginx.sh
mysql -e "CREATE DATABASE ${nom}_db;"
# mysql -e "CREATE USER '${nom}_user'@'localhost' IDENTIFIED BY 'password';"
# mysql -e "GRANT ALL PRIVILEGES ON ${nom}_db.* TO '${nom}_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
cd /var/www/html/
wget "https://wordpress.org/latest.tar.gz"
tar -xf latest.tar.gz
rm latest.tar.gz
chown -R www-data:www-data wordpress
cp wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i "s/database_name_here/${nom}_db/" wordpress/wp-config.php
sed -i "s/\(username\|password\)_here/root/" wordpress/wp-config.php
rm wordpress/readme.html
mv wordpress ${nom}
