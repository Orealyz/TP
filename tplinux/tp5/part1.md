# Partie 1 : Mise en place et maîtrise du serveur Web


- [Partie 1 : Mise en place et maîtrise du serveur Web](#partie-1--mise-en-place-et-maîtrise-du-serveur-web)
  - [1. Installation](#1-installation)
  - [2. Avancer vers la maîtrise du service](#2-avancer-vers-la-maîtrise-du-service)

![Tipiii](../pics/linux_is_a_tipi.jpg)

## 1. Installation

🖥️ **VM web.tp5.linux**

🌞 **Installer le serveur Apache**

```
[orealyz@web ~]$ sudo yum install httpd
```


🌞 **Démarrer le service Apache**

```
[orealyz@web ~]$ sudo service httpd start
Redirecting to /bin/systemctl start httpd.service
```
```
[orealyz@web ~]$ sudo service httpd status
Redirecting to /bin/systemctl status httpd.service
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
     Active: active (running) since Tue 2023-01-03 15:19:13 CET; 14s ago
       Docs: man:httpd.service(8)
   Main PID: 10862 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
      Tasks: 213 (limit: 5905)
     Memory: 23.1M
        CPU: 46ms
     CGroup: /system.slice/httpd.service
             ├─10862 /usr/sbin/httpd -DFOREGROUND
             ├─10863 /usr/sbin/httpd -DFOREGROUND
             ├─10864 /usr/sbin/httpd -DFOREGROUND
             ├─10865 /usr/sbin/httpd -DFOREGROUND
             └─10866 /usr/sbin/httpd -DFOREGROUND

Jan 03 15:19:10 web systemd[1]: Starting The Apache HTTP Server...
Jan 03 15:19:13 web httpd[10862]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name>Jan 03 15:19:13 web systemd[1]: Started The Apache HTTP Server.
Jan 03 15:19:13 web httpd[10862]: Server configured, listening on: port 80
```
```
[orealyz@web conf]$ sudo systemctl enable httpd
[sudo] password for orealyz:
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```
```
[orealyz@web conf]$  sudo ss -altnp | grep httpd
[sudo] password for orealyz:
LISTEN 0      511                *:80              *:*    users:(("httpd",pid=10866,fd=4),("httpd",pid=10865,fd=4),("httpd",pid=10864,fd=4),("httpd",pid=10862,fd=4))
```
```
[orealyz@web conf]$  sudo firewall-cmd --add-port=80/tcp --permanent
success
[orealyz@web conf]$ sudo firewall-cmd --reload
success
[orealyz@web conf]$ sudo firewall-cmd --list-all | grep ports
  ports: 80/tcp
  forward-ports:
  source-ports:
```

🌞 **TEST**

```
[orealyz@web conf]$ systemctl status httpd | grep Active
     Active: active (running) since Tue 2023-01-03 15:19:13 CET; 28min ago
```    

```
[orealyz@web conf]$ sudo systemctl is-enabled httpd
enabled
```

```
[orealyz@web conf]$ curl localhost | grep apache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   930k      0 --:--:-- --:--:-- --:--:--  930k
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
```

```
[orealyz@web conf]$ curl 10.105.1.11:80 | grep apache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  1240k      0 --:--:-- --:--:-- --:--:-- 1240k
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
```
## 2. Avancer vers la maîtrise du service

🌞 **Le service Apache...**


```
[orealyz@web conf]$ systemctl cat httpd
# /usr/lib/systemd/system/httpd.service
# See httpd.service(8) for more information on using the httpd service.

# Modifying this file in-place is not recommended, because changes
# will be overwritten during package upgrades.  To customize the
# behaviour, run "systemctl edit httpd" to create an override unit.

# For example, to pass additional options (such as -D definitions) to
# the httpd binary at startup, create an override unit (as is done by
# systemctl edit) and enter the following:

#       [Service]
#       Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
```

🌞 **Déterminer sous quel utilisateur tourne le processus Apache**

```
[orealyz@web conf]$ sudo cat /etc/httpd/conf/httpd.conf | grep ^User
User apache
```

```
[orealyz@web conf]$ ps -ef | grep apache
apache     10863   10862  0 15:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     10864   10862  0 15:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     10865   10862  0 15:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     10866   10862  0 15:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
orealyz    11268     942  0 15:59 pts/0    00:00:00 grep --color=auto apache
```
  
```
[orealyz@web conf]$ ls -al /usr/share/testpage/
total 12
drwxr-xr-x.  2 root root   24 Jan  3 15:18 .
drwxr-xr-x. 82 root root 4096 Jan  3 15:18 ..
-rw-r--r--.  1 root root 7620 Jul 27 20:05 index.html
```
🌞 **Changer l'utilisateur utilisé par Apache**


```
[orealyz@web conf]$ sudo useradd tp5-apache -d /usr/share/httpd/ -s /sbin/nologin
[sudo] password for orealyz:
$useradd: warning: the home directory /usr/share/httpd/ already exists.
useradd: Not copying any file from skel directory into it.
```

```
[orealyz@web conf]$ sudo cat /etc/httpd/conf/httpd.conf | grep ^User
User tp5-apache
```
```
[orealyz@web conf]$ ps -ef | grep tp5-apache
orealyz    11320     942  0 16:16 pts/0    00:00:00 grep --color=auto tp5-apache
```
🌞 **Faites en sorte que Apache tourne sur un autre port**


```
[orealyz@web conf]$ echo $RANDOM
1918
```
```
[orealyz@web /]$ sudo cat /etc/httpd/conf/httpd.conf | grep Listen
Listen 1918
```

```
[orealyz@web /]$ sudo firewall-cmd --add-port=1918/tcp --permanent
success
[orealyz@web /]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[orealyz@web /]$ sudo firewall-cmd --reload
success
[orealyz@web /]$ sudo firewall-cmd --list-all | grep ports
  ports: 1918/tcp
```

```
[orealyz@web /]$ sudo service httpd restart
Redirecting to /bin/systemctl restart httpd.service
```

```
[orealyz@web /]$ sudo ss -alnpt | grep httpd
LISTEN 0      511                *:1918            *:*    users:(("httpd",pid=11389,fd=4),("httpd",pid=11388,fd=4),("httpd",pid=11387,fd=4),("httpd",pid=11385,fd=4))
```
- vérifiez avec `curl` en local que vous pouvez joindre Apache sur le nouveau port
```
[orealyz@web /]$ curl http://10.105.1.11:1918 | head -n 10
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


📁 **Fichier `/etc/httpd/conf/httpd.conf`**
[httpd.conf](httpd.conf)

➜ **Si c'est tout bon vous pouvez passer à [la partie 2.]()**