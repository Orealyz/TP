# Module 1 : Reverse Proxy


## Sommaire

- [Module 1 : Reverse Proxy](#module-1--reverse-proxy)
  - [Sommaire](#sommaire)
- [I. Setup](#i-setup)
- [II. HTTPS](#ii-https)

# I. Setup

🌞 **On utilisera NGINX comme reverse proxy**

```
[orealyz@proxy ~]$ sudo dnf install nginx
```
```
[orealyz@proxy ~]$ sudo systemctl start nginx
[orealyz@proxy ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-16 12:08:44 CET; 10s ago
    Process: 1116 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1117 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1118 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1119 (nginx)
      Tasks: 2 (limit: 5905)
     Memory: 1.9M
        CPU: 13ms
     CGroup: /system.slice/nginx.service
             ├─1119 "nginx: master process /usr/sbin/nginx"
             └─1120 "nginx: worker process"

Jan 16 12:08:44 proxy.tp6.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 16 12:08:44 proxy.tp6.linux nginx[1117]: nginx: the configuration file /etc/nginx/nginx.conf synt>
Jan 16 12:08:44 proxy.tp6.linux nginx[1117]: nginx: configuration file /etc/nginx/nginx.conf test is >
Jan 16 12:08:44 proxy.tp6.linux systemd[1]: Started The nginx HTTP and reverse proxy server.
```
```
[orealyz@proxy ~]$ sudo ss -tulpn | grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1120,fd=6),("ngin
",pid=1119,fd=6))
tcp   LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1120,fd=7),("ngin
",pid=1119,fd=7))
```
```
[orealyz@proxy ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[orealyz@proxy ~]$ sudo firewall-cmd --reload
success
[orealyz@proxy ~]$ sudo firewall-cmd --list-all | grep port
  ports: 80/tcp
  forward-ports:
  source-ports:
```
```
[orealyz@proxy ~]$ sudo ps -ef | grep nginx
root        1119       1  0 12:08 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1120    1119  0 12:08 ?        00:00:00 nginx: worker process
orealyz     1155     933  0 12:11 pts/0    00:00:00 grep --color=auto nginx
```
```
[orealyz@proxy ~]$ curl http://10.105.1.3:80 | head -10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
100  7620  100  7620    0     0  1063k      0 --:--:-- --:--:-- --:--:-- 1063k
curl: (23) Failed writing body
```
🌞 **Configurer NGINX**
```
[orealyz@proxy nginx]$ sudo cat nginx.conf | grep conf
    include /etc/nginx/conf.d/*.conf;
```
```
[orealyz@web ~]$ sudo cat /var/www/tp5_nextcloud/config/config.php | grep 1
    1 => '10.105.1.3'
```
```
[orealyz@proxy conf.d]$ sudo nano proxy_tp6.conf
[sudo] password for orealyz:
[orealyz@proxy conf.d]$ sudo cat proxy_tp6.conf
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name www.nextcloud.tp6;

    # Port d'écoute de NGINX
    listen 80;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying
        proxy_pass http://<IP_DE_NEXTCLOUD>:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```


➜ **Modifier votre fichier `hosts` de VOTRE PC**

🌞 **Faites en sorte de**

- rendre le serveur `web.tp6.linux` injoignable
- sauf depuis l'IP du reverse proxy
- en effet, les clients ne doivent pas joindre en direct le serveur web : notre reverse proxy est là pour servir de serveur frontal
- **comment ?** Je vous laisser là encore chercher un peu par vous-mêmes (hint : firewall)
```
[orealyz@web ~]$ sudo firewall-cmd --remove-interface enp0s8 --zone=public --permanent
The interface is under control of NetworkManager and already bound to the default zone
The interface is under control of NetworkManager, setting zone to default.
success
[orealyz@web ~]$ sudo firewall-cmd --add-interface enp0s8 --zone=trusted --permanent
The interface is under control of NetworkManager, setting zone to 'trusted'.
success
[orealyz@web ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 80/tcp 19999/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
[orealyz@web ~]$ sudo firewall-cmd --add-port=22/tcp --permanent --zone=trusted
success
[orealyz@web ~]$ sudo firewall-cmd --add-source=10.105.1.1 --permanent --zone=trusted
success
[orealyz@web ~]$ sudo firewall-cmd --permanent --zone=trusted --set-target=DROP
success
[orealyz@web ~]$ sudo firewall-cmd --set-default-zone trusted
success
[orealyz@web ~]$ sudo firewall-cmd --reload
success
[orealyz@web ~]$ sudo firewall-cmd --list-all
trusted (active)
  target: DROP
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 10.105.1.1
  services:
  ports: 22/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

🌞 **Une fois que c'est en place**

```
PS C:\Users\b> ping 10.105.1.3

Envoi d’une requête 'Ping'  10.105.1.3 avec 32 octets de données :
Réponse de 10.105.1.3 : octets=32 temps<1ms TTL=64
Réponse de 10.105.1.3 : octets=32 temps<1ms TTL=64
Réponse de 10.105.1.3 : octets=32 temps<1ms TTL=64
Réponse de 10.105.1.3 : octets=32 temps<1ms TTL=64

Statistiques Ping pour 10.105.1.3:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
```
```
PS C:\Users\b> ping 10.105.1.11

Envoi d’une requête 'Ping'  10.105.1.11 avec 32 octets de données :
Délai d’attente de la demande dépassé.

Statistiques Ping pour 10.105.1.11:
    Paquets : envoyés = 1, reçus = 0, perdus = 1 (perte 100%),
```

# II. HTTPS

🌞 **Faire en sorte que NGINX force la connexion en HTTPS plutôt qu'HTTP**
```
[orealyz@web ~]$ openssl genrsa -aes128 2048 > server.key 
[orealyz@web ~]$ openssl rsa -in server.key -out server.key 
[orealyz@web ~]$ openssl req -utf8 -new -key server.key -out server.csr
[orealyz@web ~]$ openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 3650 
[orealyz@web ~]$ chmod 600 server.key
```
```
[orealyz@web ~]$ cat /etc/nginx/conf.d/nginx.conf 
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name www.nextcloud.tp6;

    # Port d'écoute de NGINX
    listen 443 ssl;
    server_name example.yourdomain.com;
    ssl_certificate  /home/orealyz/server.crt;
    ssl_certificate_key  /home/orealyz/server.key; 
    ssl_prefer_server_ciphers on;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```

```
[orealyz@web ~]$ sudo systemctl restart nginx
[orealyz@web ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[orealyz@web ~]$ sudo firewall-cmd --reload
success
[orealyz@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[orealyz@web ~]$ sudo firewall-cmd --reload
success
```

```
[orealyz@web ~]$ curl https://www.nextcloud.tp6
curl: (60) SSL certificate problem: self-signed certificate
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```

Pour la partie 2, it's here -> [part2](part2.md)