# TP 3 : We do a little scripting

## Sommaire

- [TP 3 : We do a little scripting](#tp-3--we-do-a-little-scripting)
  - [Sommaire](#sommaire)
- [I. Script carte d'identité](#i-script-carte-didentité)
  - [Rendu](#rendu)
- [II. Script youtube-dl](#ii-script-youtube-dl)
  - [Rendu](#rendu-1)
- [III. MAKE IT A SERVICE](#iii-make-it-a-service)
  - [Rendu](#rendu-2)
- [IV. Bonus](#iv-bonus)



# I. Script carte d'identité

## Rendu

📁 **Fichier `/srv/idcard/idcard.sh`**

[idcard](idcard.sh)

🌞 **Vous fournirez dans le compte-rendu**, en plus du fichier, **un exemple d'exécution avec une sortie**, dans des balises de code.

```
[orealyz@tp3 idcard]$ sudo ./idcard.sh
Machine name : tp3
OS Rocky Linux and kernel version is 5.14.0-70.26.1.el9_0.x86_64
IP : 10.3.1.255
RAM : 710Mi memory available on 960Mi total memory
Disque : 5.1G space left
Top 5 processes by RAM usage :
  - /usr/bin/python3 (RAM utilisé : 4.1)
  - /usr/sbin/NetworkManager (RAM utilisé : 1.9)
  - /usr/lib/systemd/systemd (RAM utilisé : 1.5)
  - /usr/lib/systemd/systemd (RAM utilisé : 1.3)
  - sshd: (RAM utilisé : 1.1)
Listening ports :
  - 323 udp : chronyd
  - 22 tcp : sshd
Here is your random cat: ./cat.gif
```



# II. Script youtube-dl

## Rendu

📁 **Le script `/srv/yt/yt.sh`**

[yt](yt.sh)

📁 **Le fichier de log `/var/log/yt/download.log`**, avec au moins quelques lignes
[download.log](download.log)

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, **un exemple d'exécution avec une sortie**, dans des balises de code.
```
[orealyz@tp3 /]$ sudo /srv/yt/yt.sh https://www.youtube.com/watch?v=e0OICsWZSss
mkdir: cannot create directory ‘/srv/yt/downloads/’: File exists
Video https://www.youtube.com/watch?v=e0OICsWZSss was downloaded.
File path : /srv/yt/downloads//.mp4
```
```
[orealyz@tp3 yt]$ sudo /srv/yt/yt.sh https://www.youtube.com/watch?v=dGiT3Y744PA
mkdir: cannot create directory ‘/srv/yt/downloads/’: File exists
mkdir: cannot create directory ‘description’: File exists
Video https://www.youtube.com/watch?v=dGiT3Y744PA was downloaded.
File path : /srv/yt/downloads//.mp4
```
```
[orealyz@tp3 yt]$ sudo /srv/yt/yt.sh https://www.youtube.com/watch?v=KXqLsMrYUcY
mkdir: cannot create directory ‘/srv/yt/downloads/’: File exists
mkdir: cannot create directory ‘description’: File exists
Video https://www.youtube.com/watch?v=KXqLsMrYUcY was downloaded.
File path : /srv/yt/downloads//.mp4
```

# III. MAKE IT A SERVICE

## Rendu

📁 **Le script `/srv/yt/yt-v2.sh`**

[yt-v2](yt-v2.sh)

📁 **Fichier `/etc/systemd/system/yt.service`**

[yt.service](yt.service)

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

- un `systemctl status yt` quand le service est en cours de fonctionnement
```
[orealyz@tp3 yt]$ systemctl status yt
● yt.service - Telechargement de videos YouTube
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor prese>
     Active: active (running) since Mon 2022-12-05 06:29:51 CET; 13min ago
   Main PID: 28792 (yt-v2.sh)
      Tasks: 2 (limit: 5907)
     Memory: 580.0K
        CPU: 160ms
     CGroup: /system.slice/yt.service
             ├─28792 /bin/bash /srv/yt/yt-v2.sh
             └─28969 sleep 5

Dec 05 06:29:51 tp3 systemd[1]: Started Telechargement de videos YouTube.
```