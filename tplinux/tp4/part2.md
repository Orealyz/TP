# Partie 2 : Serveur de partage de fichiers





🌞 **Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`**
```
[orealyz@storage ~]$ sudo dnf install nfs-utils
[orealyz@storage var]$ sudo mkdir /storage/site_web_1/ -p
[orealyz@storage /]$ sudo mkdir /storage/site_web_2/
[orealyz@storage /]$ sudo chown nobody storage/site_web_1/
[orealyz@storage /]$ sudo chown nobody storage/site_web_2/
[orealyz@storage /]$ sudo nano /etc/exports
[orealyz@storage /]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[orealyz@storage /]$ sudo systemctl start nfs-server
[orealyz@storage /]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disa>    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Mon 2023-01-02 09:46:51 CET; 5s ago
    Process: 11448 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
    Process: 11449 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
    Process: 11466 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl re>   Main PID: 11466 (code=exited, status=0/SUCCESS)
        CPU: 14ms

Jan 02 09:46:50 storage.tp4.linux systemd[1]: Starting NFS server and services...
Jan 02 09:46:51 storage.tp4.linux systemd[1]: Finished NFS server and services.
lines 1-13/13 (END)
[orealyz@storage /]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client ssh
[orealyz@storage /]$ sudo firewall-cmd --permanent --add-service=nfs
success
[orealyz@storage /]$ sudo firewall-cmd --permanent --add-service=mountd
success
[orealyz@storage /]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[orealyz@storage /]$ sudo firewall-cmd --reload
success
[orealyz@storage /]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
  [orealyz@storage site_web_1]$ sudo nano test
  [orealyz@storage site_web_2]$ sudo nano test2
```

```
[orealyz@storage etc]$ cat exports
/storage/site_web_1/    10.3.1.14(rw,sync,no_subtree_check)
/storage/site_web_2/    10.3.1.14(rw,sync,no_root_squash,no_subtree_check)
```
🌞 **Donnez les commandes réalisées sur le client NFS `web.tp4.linux`**
```
[orealyz@web ~]$ sudo dnf install nfs-utils
[orealyz@web /]$ sudo mkdir -p /var/www/site_web_1/
[orealyz@web /]$ sudo mkdir -p /storage/site_web_2/
[orealyz@web /]$ sudo mount 10.3.1.13:/storage/site_web_1/ /var/www/site_web_1/
[orealyz@web /]$ sudo mount 10.3.1.13:/storage/site_web_2/ /var/www/site_web_2/
[orealyz@web /]$ df -h
Filesystem                     Size  Used Avail Use% Mounted on
devtmpfs                       462M     0  462M   0% /dev
tmpfs                          481M     0  481M   0% /dev/shm
tmpfs                          193M  3.0M  190M   2% /run
/dev/mapper/rl-root            6.2G  1.2G  5.1G  18% /
/dev/sda1                     1014M  210M  805M  21% /boot
tmpfs                           97M     0   97M   0% /run/user/1000
10.3.1.13:/storage/site_web_1  6.2G  1.2G  5.1G  18% /var/www/site_web_1
10.3.1.13:/storage/site_web_2  6.2G  1.2G  5.1G  18% /var/www/site_web_2
[orealyz@web /]$ sudo nano /etc/fstab
```
```
[orealyz@web etc]$ cat fstab

#
# /etc/fstab
# Created by anaconda on Fri Oct 14 08:55:56 2022
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=bbfd4e65-72fb-4db2-bd84-800676f83d42 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0

10.3.1.13:/storage/site_web_1/    /var/www/site_web_1/   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
10.3.1.13:/storage/site_web_2/    /var/www/site_web_2/   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```
Tout est fonctionnel comme on peut le voir ici 😉
```
[orealyz@web /]$ cat /var/www/site_web_1/test
oui kend
[orealyz@web site_web_2]$ cat test2
ouais tern
```

Pour la partie 3, c'est ici-> [part3](part3.md)😊
