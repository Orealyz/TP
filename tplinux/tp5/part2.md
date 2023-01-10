# Partie 2 : Mise en place et maîtrise du serveur de base de données



🖥️ **VM db.tp5.linux**


🌞 **Install de MariaDB sur `db.tp5.linux`**


```
[orealyz@db ~]$ sudo dnf install mariadb-server
```
```
[orealyz@db ~]$ sudo systemctl enable mariadb
[sudo] password for orealyz:
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
```
```
[orealyz@db ~]$ sudo systemctl start mariadb
```
```
mysql_secure_installation
```

```
[orealyz@db ~]$ sudo systemctl is-enabled mariadb
enabled
```

🌞 **Port utilisé par MariaDB**


```
[orealyz@db ~]$ sudo ss -alpn | grep mariadb
u_str LISTEN 0      80                      /var/lib/mysql/mysql.sock 19154                  * 0     users:(("mariadbd",pid=802,fd=20))
tcp   LISTEN 0      80                                              *:3306                   *:*     users:(("mariadbd",pid=802,fd=19))
```
```
[orealyz@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[orealyz@db ~]$ sudo firewall-cmd --reload
success
[orealyz@db ~]$ sudo firewall-cmd --list-all | grep ports
  ports: 3306/tcp
```

🌞 **Processus liés à MariaDB**

```
[orealyz@db ~]$ sudo ps -ef | grep mariadb
mysql        802       1  0 08:59 ?        00:00:00 /usr/libexec/mariadbd --basedir=/usr
orealyz     1123     978  0 09:09 pts/0    00:00:00 grep --color=auto mariadb
```
➜ **Une fois la db en place, go sur [la partie 3.](part3.md)**