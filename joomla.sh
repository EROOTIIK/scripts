#!/bin/bash


echo "Spécifiez un nom pour votre site Joomla! :"
read nom

while [[ ! ${nom} =~ ^[0-9,a-z,A-Z,_]+$ ]]
do
    echo "Syntaxe non valide pour ${nom}"
    echo "Spécifiez un nom pour votre site Joomla! :"
	read nom
done

./nginx.sh
apt install php7.4-fpm php7.4-common php7.4-mysql php7.4-gmp php7.4-curl php7.4-intl php7.4-mbstring php7.4-xmlrpc php7.4-gd php7.4-xml php7.4-cli php7.4-zip -y
cd /var/www/html/
# wget $(wget -qO- api.github.com/repos/joomla/joomla-cms/releases | jq -r 'map(.[] | select(.prerelease==false) | .assets[1] | .browser_download_url])[0]') -O joomla.tar.gz
wget $(wget -O - https://downloads.joomla.org/fr/latest | grep -io '<a href=['"'"'"][^"'"'"']*gz['"'"'"]' | head -1 | sed -e 's/^<a href=["'"'"']/https:\/\/downloads.joomla.org/i') -O joomla.tar.gz
mkdir joomla
tar xf joomla.tar.gz -C joomla
rm joomla.tar.gz
chown -R www-data:www-data joomla
sed -i "s/\(minimumLength.*\)12;/\13;/" joomla/libraries/src/Form/Rule/PasswordRule.php
mv joomla ${nom}
service nginx restart
mysql -e "CREATE DATABASE ${nom}_db;"
# mysql -e "CREATE USER '${nom}_user'@'localhost' IDENTIFIED BY 'password';"
# mysql -e "GRANT ALL PRIVILEGES ON ${nom}_db.* TO '${nom}_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
