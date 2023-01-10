# Partie 3 : Configuration et mise en place de NextCloud

- [Partie 3 : Configuration et mise en place de NextCloud](#partie-3--configuration-et-mise-en-place-de-nextcloud)
  - [1. Base de données](#1-base-de-données)
  - [2. Serveur Web et NextCloud](#2-serveur-web-et-nextcloud)
  - [3. Finaliser l'installation de NextCloud](#3-finaliser-linstallation-de-nextcloud)

## 1. Base de données

🌞 **Préparation de la base pour NextCloud**

```
[orealyz@db ~]$ sudo mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 13
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

```
[orealyz@db ~]$ sudo mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 13
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'nextcloud'@'10.105.1.11' IDENTIFIED BY 'pewpewpew';

    -> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

    -> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.105.1.11';

    -> FLUSH PRIVILEGES;
```

🌞 **Exploration de la base de données**


```
[orealyz@web ~]$ sudo dnf install mysql
```

```
[orealyz@web ~]$ mysql -u nextcloud -h 10.105.1.12 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.5.5-10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.00 sec)

mysql> USE nextcloud;
Database changed
mysql> SHOW TABLES;
Empty set (0.00 sec)
```

🌞 **Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données**

```
[orealyz@db ~]$ sudo mysql -u root -p
[sudo] password for orealyz:
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 5
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> use mysql;SELECT user FROM user;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
+-------------+
| User        |
+-------------+
| nextcloud   |
| mariadb.sys |
| mysql       |
| root        |
+-------------+
4 rows in set (0.000 sec)               
```

## 2. Serveur Web et NextCloud


```
[orealyz@web conf]$ sudo firewall-cmd --add-port=80/tcp --permament
usage: see firewall-cmd man page
firewall-cmd: error: unrecognized arguments: --permament
[orealyz@web conf]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[orealyz@web conf]$ sudo firewall-cmd --remove-port=1918/tcp --permanent
success
[orealyz@web conf]$ sudo firewall-cmd --reload
success
```
🌞 **Install de PHP**

```
[orealyz@web conf]$ sudo dnf config-manager --set-enabled crb
[orealyz@web conf]$ sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
```
```
[orealyz@web conf]$ dnf module list php
[orealyz@web conf]$ sudo dnf module enable php:remi-8.1 -y
[orealyz@web conf]$ sudo dnf install -y php81-php
```
🌞 **Install de tous les modules PHP nécessaires pour NextCloud**

```
[orealyz@web conf]$ sudo dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp
```
🌞 **Récupérer NextCloud**

```
[orealyz@web conf]$ sudo mkdir /var/www/tp5_nextcloud/
```


```
[orealyz@web conf]$ sudo dnf install wget -y
```

```
[orealyz@web tp5_nextcloud]$ sudo dnf install unzip
```
```
[orealyz@web tp5_nextcloud]$ sudo wget https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
```
```
[orealyz@web tp5_nextcloud]$ sudo unzip nextcloud-25.0.0rc3.zip
```
```
[orealyz@web tp5_nextcloud]$ cd nextcloud
```
```
[orealyz@web tp5_nextcloud]$ sudo chown apache *
```
🌞 **Adapter la configuration d'Apache**

```
[orealyz@web conf.d]$ sudo cat nextcloud.conf
<VirtualHost *:80>
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
</VirtualHost>```


```

🌞 **Redémarrer le service Apache** pour qu'il prenne en compte le nouveau fichier de conf
```
[orealyz@web conf.d]$ sudo systemctl restart httpd
```

## 3. Finaliser l'installation de NextCloud

➜ **Sur votre PC**


🌞 **Exploration de la base de données**


➜ **NextCloud est tout bo, en place, vous pouvez aller sur [la partie 4.](part4.md)**
