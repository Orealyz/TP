# Partie 4 : Automatiser la résolution du TP
```
setenforce 0

dnf update -y
dnf install -y httpd

dnf config-manager --set-enabled crb
dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
dnf module list php -y
dnf module enable php:remi-8.1 -y
dnf install -y php81-php unzip
dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp

cd /tmp
[[ ! -f nextcloud-25.0.0rc3.zip ]] && curl -SLO https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
unzip nextcloud-25.0.0rc3.zip

mkdir /var/www/tp5_nextcloud
mv nextcloud/* /var/www/tp5_nextcloud/
mv nextcloud/.* /var/www/tp5_nextcloud/
chown -R apache:apache /var/www/tp5_nextcloud/

echo "<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp5_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web.tp5.linux

  # on définit des règles d'accès sur notre webroot
  <Directory /var/www/tp5_nextcloud/> 
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>" > /etc/httpd/conf.d/nextcloud.conf
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
systemctl enable --now httpd
cd
```
- crée un fichier "NOM"
- met le code ci-dessus dans le fichier créé "NOM"
- exécute le script avec la commande sudo bash "NOM"