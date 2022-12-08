# TP2 : Appréhender l'environnement Linux

# Sommaire

- [TP2 : Appréhender l'environnement Linux](#tp2--appréhender-lenvironnement-linux)
- [Sommaire](#sommaire)
  - [Checklist](#checklist)
- [I. Service SSH](#i-service-ssh)
  - [1. Analyse du service](#1-analyse-du-service)
  - [2. Modification du service](#2-modification-du-service)
- [II. Service HTTP](#ii-service-http)
  - [1. Mise en place](#1-mise-en-place)
  - [2. Analyser la conf de NGINX](#2-analyser-la-conf-de-nginx)
  - [3. Déployer un nouveau site web](#3-déployer-un-nouveau-site-web)
- [III. Your own services](#iii-your-own-services)
  - [1. Au cas où vous auriez oublié](#1-au-cas-où-vous-auriez-oublié)
  - [2. Analyse des services existants](#2-analyse-des-services-existants)
  - [3. Création de service](#3-création-de-service)


# I. Service SSH

## 1. Analyse du service

🌞 **S'assurer que le service `sshd` est démarré**

- avec une commande `systemctl status`
 ```
[orealyz@tp2 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-12-05 11:18:43 CET; 7min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 712 (sshd)
      Tasks: 1 (limit: 5905)
     Memory: 5.6M
        CPU: 64ms
     CGroup: /system.slice/sshd.service
             └─712 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Dec 05 11:18:43 tp2 systemd[1]: Starting OpenSSH server daemon...
Dec 05 11:18:43 tp2 sshd[712]: Server listening on 0.0.0.0 port 22.
Dec 05 11:18:43 tp2 sshd[712]: Server listening on :: port 22.
Dec 05 11:18:43 tp2 systemd[1]: Started OpenSSH server daemon.
Dec 05 11:19:49 tp2 sshd[867]: Accepted password for orealyz from 10.3.1.1 port 64142 ssh2
Dec 05 11:19:49 tp2 sshd[867]: pam_unix(sshd:session): session opened for user orealyz(uid=1000) by (uid=0)
 ```

🌞 **Analyser les processus liés au service SSH**

- afficher les processus liés au service `sshd`
  - vous pouvez afficher la liste des processus en cours d'exécution avec une commande `ps`
  - pour le compte-rendu, vous devez filtrer la sortie de la commande en ajoutant `| grep <TEXTE_RECHERCHE>` après une commande
    - exemple :
 ```
    [orealyz@tp2 ~]$ ps -ef | grep sshd
root         712       1  0 11:18 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         867     712  0 11:19 ?        00:00:00 sshd: orealyz [priv]
orealyz      871     867  0 11:19 ?        00:00:00 sshd: orealyz@pts/0
orealyz      940     872  0 11:29 pts/0    00:00:00 grep --color=auto sshd
 ```


🌞 **Déterminer le port sur lequel écoute le service SSH**

 ```
[orealyz@tp2 ~]$ sudo ss -alnpt | grep ssh
[sudo] password for orealyz:
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=712,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=712,fd=4))
```

🌞 **Consulter les logs du service SSH**

 ```
[orealyz@tp2 ~]$ journalctl -xe -u sshd -f
Dec 05 11:18:43 tp2 systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 217.
Dec 05 11:18:43 tp2 sshd[712]: Server listening on 0.0.0.0 port 22.
Dec 05 11:18:43 tp2 sshd[712]: Server listening on :: port 22.
Dec 05 11:18:43 tp2 systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 217.
Dec 05 11:19:49 tp2 sshd[867]: Accepted password for orealyz from 10.3.1.1 port 64142 ssh2
Dec 05 11:19:49 tp2 sshd[867]: pam_unix(sshd:session): session opened for user orealyz(uid=1000) by (uid=0)
 ```
 ```
[orealyz@tp2 log]$ sudo tail -n 10 secure
Dec  5 11:41:56 tp2 sudo[974]: pam_unix(sudo:session): session closed for user root
Dec  5 11:42:27 tp2 sudo[978]: orealyz : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cd sssd/
Dec  5 11:42:27 tp2 sudo[978]: pam_unix(sudo:session): session opened for user root(uid=0) by orealyz(uid=1000)
Dec  5 11:42:27 tp2 sudo[978]: pam_unix(sudo:session): session closed for user root
Dec  5 11:44:31 tp2 sudo[985]: orealyz : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/nano lastlog
Dec  5 11:44:31 tp2 sudo[985]: pam_unix(sudo:session): session opened for user root(uid=0) by orealyz(uid=1000)
Dec  5 11:44:36 tp2 sudo[985]: pam_unix(sudo:session): session closed for user root
Dec  5 11:45:24 tp2 sudo[988]: orealyz : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/nano secure
Dec  5 11:45:24 tp2 sudo[988]: pam_unix(sudo:session): session opened for user root(uid=0) by orealyz(uid=1000)
Dec  5 11:45:32 tp2 sudo[988]: pam_unix(sudo:session): session closed for user root
 ```
![When she tells you](./pics/when_she_tells_you.png)

## 2. Modification du service


🌞 **Identifier le fichier de configuration du serveur SSH**
 ```
 [orealyz@tp2 /]$ sudo nano /etc/ssh/sshd_config
 ```
🌞 **Modifier le fichier de conf**

 ```
  [orealyz@tp2 /]$ echo $RANDOM
21161
 ```

 ```
[orealyz@tp2 ~]$ sudo cat /etc/ssh/sshd_config | grep 21161
Port 21161
```

```
[orealyz@tp2 ~]$ sudo firewall-cmd --remove-service=ssh --permanent
```
```
[orealyz@tp2 ~]$ sudo firewall-cmd --add-port=21161/tcp --permanent
success
```

```
[orealyz@tp2 ~]$ sudo firewall-cmd --list-all | grep 21161
  ports: 21161/tcp
```
🌞 **Redémarrer le service**
```
[orealyz@tp2 ~]$ sudo systemctl restart sshd
```

🌞 **Effectuer une connexion SSH sur le nouveau port**

```
PS C:\Users\b> ssh -p 21161 orealyz@10.3.1.10
orealyz@10.3.1.10's password:
Last login: Mon Dec  5 12:21:23 2022
``` 

![Such a hacker](./pics/such_a_hacker.png)

# II. Service HTTP

## 1. Mise en place

![nngijgingingingijijnx ?](./pics/njgjgijigngignx.jpg)

🌞 **Installer le serveur NGINX**

```
[orealyz@tp2 ~]$ sudo dnf install nginx

[orealyz@tp2 ~]$ sudo systemctl enable nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
```

🌞 **Démarrer le service NGINX**
```
[orealyz@tp2 ~]$ sudo systemctl start nginx
```

🌞 **Déterminer sur quel port tourne NGINX**


 ```
[orealyz@tp2 ~]$ sudo ss -alnpt | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=10722,fd=6),("nginx",pid=10721,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=10722,fd=7),("nginx",pid=10721,fd=7))
 ```
 ```
[orealyz@tp2 ~]$ sudo firewall-cmd --add-port=80/tcp
success
 ```


🌞 **Déterminer les processus liés à l'exécution de NGINX**

 ```
 [orealyz@tp2 ~]$ ps -ef | grep nginx
root       10721       1  0 14:15 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      10722   10721  0 14:15 ?        00:00:00 nginx: worker process
orealyz    10783     865  0 14:23 pts/0    00:00:00 grep --color=auto nginx
 ```

🌞 **Euh wait**

 ```
 [orealyz@tp2 ~]$ curl
curl: try 'curl --help' or 'curl --manual' for more information
[orealyz@tp2 ~]$ curl 10.3.1.10:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
100  7620  100  7620    0     0   826k      0 --:--:-- --:--:-- --:--:--  826k
curl: (23) Failed writing body
 ```

## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**

 ```
[orealyz@tp2 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 31 16:37 /etc/nginx/nginx.conf
 ```

🌞 **Trouver dans le fichier de conf**

 ```
[orealyz@tp2 ~]$ cat /etc/nginx/nginx.conf | grep -m 1 'server {' -A 16
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
  ```
  ```
[orealyz@tp2 ~]$ cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
  ```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**

 ```
  [orealyz@tp2 ~]$ sudo mkdir /var/www
  [sudo] password for orealyz:
 ```
 ```
[orealyz@tp2 ~]$ sudo mkdir /var/www/tp2_linux
 ```
 ```
[orealyz@tp2 ~]$ sudo nano /var/www/tp2_linux/index.html
 ```

🌞 **Adapter la conf NGINX**

 ```
[orealyz@tp2 ~]$ echo $RANDOM
24015
 ```

 ```
[orealyz@tp2 nginx]$ sudo nano /etc/nginx/conf.d/tp2.conf
server {
  listen 24015;

  root /var/www/tp2_linux;
}
 ```

 ```
[orealyz@tp2 nginx]$ sudo systemctl restart nginx
 ```

  ```
[orealyz@tp2 nginx]$ sudo firewall-cmd --add-port=24015/tcp --permanent
success
  ```

  ```
[orealyz@tp2 nginx]$ sudo firewall-cmd --reload
success
  ```
  ```
[orealyz@tp2 nginx]$ sudo firewall-cmd --list-all | grep -m 1 ports
  ports: 22/tcp 24015/tcp
  ```

🌞 **Visitez votre super site web**

 ```
[orealyz@tp2 nginx]$ curl 10.3.1.10:24015
<h1>MEOW mon premier serveur web</h1>
 ```

# III. Your own services


## 1. Au cas où vous auriez oublié

## 2. Analyse des services existants


🌞 **Afficher le fichier de service SSH**

 ```
[orealyz@tp2 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-12-07 13:24:43 CET; 11min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 683 (sshd)
      Tasks: 1 (limit: 5905)
     Memory: 5.8M
        CPU: 43ms
     CGroup: /system.slice/sshd.service
             └─683 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Dec 07 13:24:43 tp2 systemd[1]: Starting OpenSSH server daemon...
Dec 07 13:24:43 tp2 sshd[683]: Server listening on 0.0.0.0 port 22.
Dec 07 13:24:43 tp2 sshd[683]: Server listening on :: port 22.
Dec 07 13:24:43 tp2 systemd[1]: Started OpenSSH server daemon.
Dec 07 13:25:31 tp2 sshd[868]: Accepted password for orealyz from 10.3.1.1 port 59277 ssh2
Dec 07 13:25:31 tp2 sshd[868]: pam_unix(sshd:session): session opened for user orealyz(uid=1000) by (uid=0)
 ```

 ```
[orealyz@tp2 ~]$ sudo cat /usr/lib/systemd/system/sshd.service | grep ExecStart
[sudo] password for orealyz:
ExecStart=/usr/sbin/sshd -D $OPTIONS
 ```

🌞 **Afficher le fichier de service NGINX**
 ```
[orealyz@tp2 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Wed 2022-12-07 13:24:43 CET; 18min ago
    Process: 806 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 807 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 813 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 814 (nginx)
      Tasks: 2 (limit: 5905)
     Memory: 3.7M
        CPU: 12ms
     CGroup: /system.slice/nginx.service
             ├─814 "nginx: master process /usr/sbin/nginx"
             └─819 "nginx: worker process"

Dec 07 13:24:43 tp2 systemd[1]: Starting The nginx HTTP and reverse proxy server...
Dec 07 13:24:43 tp2 nginx[807]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Dec 07 13:24:43 tp2 nginx[807]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Dec 07 13:24:43 tp2 systemd[1]: Started The nginx HTTP and reverse proxy server.
 ```
 ```
[orealyz@tp2 ~]$ sudo cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
 ```


## 3. Création de service

![Create service](./pics/create_service.png)


🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**
 ```
[orealyz@tp2 ~]$ echo $RANDOM
17351
 ```

 ```
[orealyz@tp2 ~]$ sudo nano /etc/systemd/system/tp2_nc.service
 ```

 ```
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l <17351>

 ```

 ```
[orealyz@tp2 ~]$ sudo firewall-cmd --add-port=17351/tcp --permanent
success
[orealyz@tp2 ~]$ sudo firewall-cmd --reload
success
[orealyz@tp2 ~]$ sudo firewall-cmd --list-all | grep 17351
  ports: 22/tcp 24015/tcp 8888/tcp 17351/tcp
 ```


```service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l <PORT>
```


🌞 **Indiquer au système qu'on a modifié les fichiers de service**
```
[orealyz@tp2 ~]$ sudo systemctl daemon-reload
```
- la commande c'est `sudo systemctl daemon-reload`

🌞 **Démarrer notre service de ouf**

- avec une commande `systemctl start`
```
[orealyz@tp2 ~]$ sudo systemctl start tp2_nc
```
🌞 **Vérifier que ça fonctionne**

 ```
[orealyz@tp2 ~]$ sudo systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Wed 2022-12-07 13:59:41 CET; 10s ago
   Main PID: 1142 (nc)
      Tasks: 1 (limit: 5905)
     Memory: 780.0K
        CPU: 1ms
     CGroup: /system.slice/tp2_nc.service
             └─1142 /usr/bin/nc -l 17351

Dec 07 13:59:41 tp2 systemd[1]: Started Super netcat tout fou.
 ```
```
[orealyz@tp2 ~]$ sudo ss -alnpt | grep 17351
LISTEN 0      10           0.0.0.0:17351      0.0.0.0:*    users:(("nc",pid=1142,fd=4))
LISTEN 0      10              [::]:17351         [::]:*    users:(("nc",pid=1142,fd=3))
```

 ```
[orealyz@localhost ~]$ nc 10.3.1.10 17351
hola
hey
 ```

🌞 Les logs de votre service

mais euh, ça s'affiche où les messages envoyés par le client ? Dans les logs !
sudo journalctl -xe -u tp2_nc pour visualiser les logs de votre service
sudo journalctl -xe -u tp2_nc -f pour visualiser en temps réel les logs de votre service
-f comme follow (on "suit" l'arrivée des logs en temps réel)
dans le compte-rendu je veux
une commande journalctl filtrée avec grep qui affiche la ligne qui indique le démarrage du service
une commande journalctl filtrée avec grep qui affiche un message reçu qui a été envoyé par le client
une commande journalctl filtrée avec grep qui affiche la ligne qui indique l'arrêt du service

 ```
[orealyz@tp2 ~]$ sudo journalctl -xe -u tp2_nc | grep start
░░ Subject: A start job for unit tp2_nc.service has finished successfully
░░ A start job for unit tp2_nc.service has finished successfully.
 ```
 ```
 [orealyz@tp2 ~]$ sudo journalctl -xe -u tp2_nc | grep "oui"
Dec 07 18:54:58 tp2 nc[934]: oui
 ```
 ```
[orealyz@tp2 ~]$  sudo journalctl -xe -u tp2_nc | grep stop
░░ Subject: A stop job for unit tp2_nc.service has begun execution
░░ A stop job for unit tp2_nc.service has begun execution.
 ```

🌞 Affiner la définition du service

 ```
[orealyz@tp2 ~]$ sudo nano /etc/systemd/system/tp2_nc.service

[orealyz@tp2 ~]$  cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 17351
Restart=always
 ```
 ```
[orealyz@tp2 ~]$ sudo systemctl daemon-reload
 ```