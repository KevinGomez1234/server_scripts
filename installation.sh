#!/bin/sh
sudo apt update;
sudo apt install -y apache2;
systemctl start apache2;
systemctl enable apache2;
systemctl status apache2;
for svc in ssh http https
do
ufw allow $svc
done
sudo ufw enable
#to check if apache server is working check localhost
sudo apt install -y libapache2-mod-php php php-common php-xml php-gd php-opcache php-mbstring php-tokenizer php-json php-bcmath php-zip unzip;
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.4/apache2/php.ini;
systemctl restart apache2;
apt install -y curl;
curl -sS https://getcomposer.org/installer | php;
sudo mv composer.phar /usr/local/bin/composer;
composer --version;
composer global require laravel/installer;
echo "export PATH=\"$HOME/.config/composer/vendor/bin:$PATH\"" >> ~/.bashrc;
source ~/.bashrc;
echo $PATH;
cd /var/www/;
chown -Rv root:$USER .;
sudo chmod -Rv g+rw .;
composer create-project --prefer-dist laravel/laravel Meridian;
cd Meridian;
composer require laravel/ui;
php artisan ui react;
npm install;
npm run dev;
chown -R www-data:www-data /var/www/Meridian;
chmod -R 775 /var/www/Meridian/storage;
cd /etc/apache2/sites-available/;
cp 000-default.conf laravel.conf;
sed -i "s/DocumentRoot\s\/var\/www\/html/DocumentRoot \/var\/www\/Meridian\/public" laravel.conf;
sed -i "19i \\\t<Directory \/var\/www\/Meridian\/public>" laravel.conf;
sed -i "20i \\\t        Options -Indexes +FollowSymLinks +MultiViews" laravel.conf;
sed -i "21i \\\t        AllowOverride all" laravel.conf;
sed -i "22i \\\t        Require all granted" laravel.conf;
sed -i "23i \\\t<\/Directory>" laravel.conf;

a2enmod rewrite;
a2ensite laravel.conf;
apachectl configtest;
systemctl restart apache2;
