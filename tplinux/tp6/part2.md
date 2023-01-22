# Module 2 : Sauvegarde du système de fichiers

## Sommaire

- [Module 2 : Sauvegarde du système de fichiers](#module-2--sauvegarde-du-système-de-fichiers)
  - [Sommaire](#sommaire)
  - [I. Script de backup](#i-script-de-backup)
    - [1. Ecriture du script](#1-ecriture-du-script)
    - [2. Clean it](#2-clean-it)
    - [3. Service et timer](#3-service-et-timer)
  - [II. NFS](#ii-nfs)
    - [1. Serveur NFS](#1-serveur-nfs)
    - [2. Client NFS](#2-client-nfs)

## I. Script de backup

### 1. Ecriture du script

➜ **Commentez le script**

```
[orealyz@web srv]$ sudo cat tp6_backup.sh
[sudo] password for orealyz:
#!/bin/bash

#Date
date=`date +"%y%m%d%H%M%S"`
#Nom du fichier
filename=nextcloud-backup_$date.zip
#Archive du mode maintenance de nextcloud
sed -i "s/'maintenance' => false,/'maintenance' => true,/" /var/www/tp5_nextcloud/config/config.php
#Archive le dossier nextcloud
cd /srv/backup
zip -r $filename /var/www/tp5_nextcloud > /dev/null
#Désactive le mode maintenance de nextcloud
sed -i "s/'maintenance' => true,/'maintenance' => false,/" /var/www/tp5_nextcloud/config/config.php

echo "Zip folder available /srv/backup/$filename"


#Script réalisé par Martin Regueme, le 17/01/2023
#Le script va permettre une sauvegarde de toutes les données de nextcloud permettant de récupérer les données en cas de perte.
#On va donc activer le mode de maintenance sur nextcloud, l'archiver et ensuite désactiver le mode de maintenance
```

➜ **Environnement d'exécution du script**

```
[orealyz@web srv]$ sudo useradd -m -d /srv/backup/ -s /usr/sbin/nologin backup
```
```
[orealyz@web srv]$ sudo -u backup /srv/tp6_backup.sh
```
### 3. Service et timer

🌞 **Créez un *service*** système qui lance le script

```
[orealyz@web system]$ sudo cat backup.service
[Unit]
Description=Ce petit service permet de faire des backup du dossier nextcloud

[Service]
Type=oneshot
ExecStart=/srv/tp6_backup.sh
User=backup
```

🌞 **Créez un *timer*** système qui lance le *service* à intervalles réguliers


```systemd
[Unit]
Description=Run service X

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
```
🌞 Activez l'utilisation du *timer*

```
[orealyz@web ~]$ cat /etc/systemd/system/backup.timer
[Unit]
Description=Run backup service

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
```

```
[orealyz@web ~]$ sudo systemctl list-timers
NEXT                        LEFT         LAST                        PASSED       UNIT              >
Fri 2023-01-06 16:00:30 CET 1h 5min left Fri 2023-01-06 14:21:17 CET 34min ago    dnf-makecache.time>
Sat 2023-01-07 00:00:00 CET 9h left      Fri 2023-01-06 13:45:04 CET 1h 10min ago logrotate.timer   >
Sat 2023-01-07 04:00:00 CET 13h left     n/a                         n/a          backup.timer      >
Sat 2023-01-07 14:00:07 CET 23h left     Fri 2023-01-06 14:00:07 CET 55min ago    systemd-tmpfiles-c>

4 timers listed.
Pass --all to see loaded but inactive timers, too.
```
## II. NFS

### 1. Serveur NFS


🖥️ **VM `storage.tp6.linux`**

🌞 **Préparer un dossier à partager sur le réseau** (sur la machine `storage.tp6.linux`)

```
[orealyz@web ~]$ sudo mkdir -p /srv/nfs_shares/web.tp6.linux/
```
🌞 **Installer le serveur NFS** (sur la machine `storage.tp6.linux`)

```
[orealyz@web ~]$ sudo dnf install nfs-utils -y
[orealyz@web ~]$ sudo systemctl enable nfs-server
[orealyz@web ~]$ sudo systemctl start nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[orealyz@web ~]$ sudo systemctl start nfs-server
[orealyz@web ~]$ sudo firewall-cmd --permanent --add-service=nfs
success
[orealyz@web ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
[orealyz@web ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[orealyz@web ~]$ sudo firewall-cmd --reload
success
[orealyz@web ~]$ cat /etc/exports
/srv/nfs_shares/web.tp6.linux/	10.105.1.11(rw,sync,no_root_squash,insecure)
```

### 2. Client NFS

🌞 **Installer un client NFS sur `web.tp6.linux`**

```
[orealyz@web ~]$ sudo dnf install nfs-utils -y
[orealyz@web ~]$ sudo firewall-cmd --permanent --zone=home --add-source=10.105.1.20
success
[orealyz@web ~]$ sudo firewall-cmd --reload
[orealyz@web ~]$ sudo mount 10.105.1.20:/srv/nfs_shares/web.tp6.linux/ /srv/backup/
[orealyz@web ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Sat Oct 15 12:47:23 2022
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=2df805a9-4569-4da4-8afe-e3ee298680df /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0

10.105.1.20:/srv/nfs_shares/web.tp6.linux/ /srv/backup/ ext4 defaults 0 0
```
🌞 **Tester la restauration des données** sinon ça sert à rien :)


Pour la partie 3, it's here -> [part3](part3.md)