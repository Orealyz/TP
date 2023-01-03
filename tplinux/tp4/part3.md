# Partie 3 : Serveur web

- [Partie 3 : Serveur web](#partie-3--serveur-web)
  - [1. Intro NGINX](#1-intro-nginx)
  - [2. Install](#2-install)
  - [3. Analyse](#3-analyse)
  - [4. Visite du service web](#4-visite-du-service-web)
  - [5. Modif de la conf du serveur web](#5-modif-de-la-conf-du-serveur-web)
  - [6. Deux sites web sur un seul serveur](#6-deux-sites-web-sur-un-seul-serveur)

## 2. Install

🖥️ **VM web.tp4.linux**

🌞 **Installez NGINX**

```
[orealyz@web ~]$ sudo dnf install nginx
```

## 3. Analyse

```bash
$ sudo systemctl start nginx
$ sudo systemctl status nginx
```

🌞 **Analysez le service NGINX**

```
[orealyz@web ~]$ ps -ef | grep nginx
root        2383       1  0 11:18 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       2384    2383  0 11:18 ?        00:00:00 nginx: worker process
orealyz     2393     850  0 11:23 pts/0    00:00:00 grep --color=auto nginx
```

```
[orealyz@web ~]$ sudo ss -alnp | grep nginx
tcp   LISTEN 0      511                                       0.0.0.0:80               0.0.0.0:*     users:(("nginx",pid=2384,fd=6),("nginx",pid=2383,fd=6))

tcp   LISTEN 0      511                                          [::]:80                  [::]:*     users:(("nginx",pid=2384,fd=7),("nginx",pid=2383,fd=7))

[orealyz@web ~]$ sudo ss -alnp | grep nginx
tcp   LISTEN 0      511                                       0.0.0.0:80               0.0.0.0:*     users:(("nginx",pid=2384,fd=6),("nginx",pid=2383,fd=6))

tcp   LISTEN 0      511                                          [::]:80                  [::]:*     users:(("nginx",pid=2384,fd=7),("nginx",pid=2383,fd=7))
```

```
[orealyz@web ~]$  cat /etc/nginx/nginx.conf | grep root
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
```

```
[orealyz@web ~]$ ls -al /usr/share/nginx/html/
total 12
drwxr-xr-x. 3 root root  143 Jan  2 11:11 .
drwxr-xr-x. 4 root root   33 Jan  2 11:11 ..
-rw-r--r--. 1 root root 3332 Oct 31 16:35 404.html
-rw-r--r--. 1 root root 3404 Oct 31 16:35 50x.html
drwxr-xr-x. 2 root root   27 Jan  2 11:11 icons
lrwxrwxrwx. 1 root root   25 Oct 31 16:37 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 31 16:35 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 31 16:37 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 31 16:37 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png

```

## 4. Visite du service web

🌞 **Configurez le firewall pour autoriser le trafic vers le service NGINX**

```
[orealyz@web ~]$ sudo firewall-cmd --list-all | grep 80
  ports: 80/tcp 22/tcp
```
🌞 **Accéder au site web**

```
[orealyz@web ~]$ curl http://10.3.1.14:80 -s | head -n 10
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
```

🌞 **Vérifier les logs d'accès**

```
[orealyz@web ~]$ sudo cat /var/log/nginx/access.log | tail -n 3
[sudo] password for orealyz:
10.3.1.14 - - [02/Jan/2023:11:40:47 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
10.3.1.14 - - [02/Jan/2023:11:42:31 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
10.3.1.14 - - [02/Jan/2023:11:42:37 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
```
## 5. Modif de la conf du serveur web

🌞 **Changer le port d'écoute**

  ```
[orealyz@web ~]$ sudo cat /etc/nginx/nginx.conf | grep 8080
        listen       8080;
        listen       [::]:8080;
```

```
[orealyz@web ~]$ sudo systemctl restart nginx
[orealyz@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-02 12:00:12 CET; 11s ago
    Process: 2551 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 2552 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 2553 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 2554 (nginx)
      Tasks: 2 (limit: 5905)
     Memory: 1.9M
        CPU: 12ms
     CGroup: /system.slice/nginx.service
             ├─2554 "nginx: master process /usr/sbin/nginx"
             └─2555 "nginx: worker process"

Jan 02 12:00:11 web systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 02 12:00:12 web nginx[2552]: nginx: the configuration file /etc/nginx/nginx.conf syntax i>
Jan 02 12:00:12 web nginx[2552]: nginx: configuration file /etc/nginx/nginx.conf test is succ>
Jan 02 12:00:12 web systemd[1]: Started The nginx HTTP and reverse proxy server.
lines 1-18/18 (END)
```

```
  [orealyz@web ~]$ sudo ss -alnp | grep nginx
tcp   LISTEN 0      511                                       0.0.0.0:8080             0.0.0.0:*     users:(("nginx",pid=2555,fd=6),("nginx",pid=2554,fd=6))

tcp   LISTEN 0      511                                          [::]:8080                [::]:*     users:(("nginx",pid=2555,fd=7),("nginx",pid=2554,fd=7))
```

```
[orealyz@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[orealyz@web ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[orealyz@web ~]$ sudo firewall-cmd --reload
success
```

```
[orealyz@web ~]$ curl http://10.3.1.14:8080 -s | head -n 10
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
```

---

🌞 **Changer l'utilisateur qui lance le service**

```
  [orealyz@web ~]$ sudo useradd web -m
[sudo] password for orealyz:
```

```
[orealyz@web ~]$ sudo passwd web
Changing password for user web.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
Sorry, passwords do not match.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
```

```
  [orealyz@web ~]$ sudo cat /etc/nginx/nginx.conf | grep web
user web;
```

```
[orealyz@web ~]$ sudo systemctl restart nginx
```

```
  [orealyz@web ~]$  sudo ps -ef | grep web
web         2655    2654  0 12:19 ?        00:00:00 nginx: worker process
orealyz     2666     850  0 12:20 pts/0    00:00:00 grep --color=auto web
```



🌞 **Changer l'emplacement de la racine Web**


```
[orealyz@web ~]$ sudo cat /etc/nginx/nginx.conf | grep site_web_1
[sudo] password for orealyz:
        root         /var/www/site_web_1/;
```

```
[orealyz@web ~]$ sudo systemctl restart nginx
```

```
[orealyz@web site_web_1]$ curl http://10.3.1.14:8080
<html>
<head><title>si</title></head>
<body>
<center><h1>yes</h1></center>
<hr><center>oui</center>
</body>
</html>
```

🌞 **Repérez dans le fichier de conf**

```
[orealyz@web site_web_1]$ cat /etc/nginx/nginx.conf | grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```


🌞 **Créez le fichier de configuration pour le premier site**


```
[orealyz@web site_web_1]$ sudo cat /etc/nginx/conf.d/site_web_1.conf
 server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /var/www/site_web_2;

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
🌞 **Créez le fichier de configuration pour le deuxième site**

```
[orealyz@web site_web_1]$ sudo cp /etc/nginx/conf.d/site_web_1.conf /etc/nginx/conf.d/site_web_2.conf
```
```
[orealyz@web site_web_1]$ sudo cat /etc/nginx/conf.d/site_web_2.conf
 server {
        listen       8888;
        listen       [::]:8888;
        server_name  _;
        root         /var/www/site_web_2;

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
[orealyz@web site_web_1]$ sudo firewall-cmd --add-port=8888/tcp --permanent
success
[orealyz@web site_web_1]$ sudo firewall-cmd --reload
success
[orealyz@web site_web_1]$ sudo firewall-cmd --list-all | grep ports:
  ports: 22/tcp 8080/tcp 8888/tcp
  forward-ports:
  source-ports:
```


🌞 **Prouvez que les deux sites sont disponibles**


Site 1 😉
```
[orealyz@web site_web_2]$ curl http://10.3.1.14:8080
<html>
<head><title>si</title></head>
<body>
<center><h1>yes</h1></center>
<hr><center>oui</center>
</body>
</html>
```
Site 2 😉
```
[orealyz@web site_web_2]$ curl http://10.3.1.14:8888
<p> holas muchas </p>
```