# Module 4 : Monitoring

Dans ce sujet on va installer un outil plutôt clé en main pour mettre en place un monitoring simple de nos machines.

L'outil qu'on va utiliser est [Netdata](https://learn.netdata.cloud/docs/agent/packaging/installer/methods/kickstart).

![Netdata](../pics/netdata.png)

🌞 **Installer Netdata**

- je vous laisse suivre la doc pour le mettre en place [ou ce genre de lien](https://wiki.crowncloud.net/?How_to_Install_Netdata_on_Rocky_Linux_9)
- vous n'avez PAS besoin d'utiliser le "Netdata Cloud" machin truc. Faites simplement une install locale.
- installez-le sur `web.tp6.linux` et `db.tp6.linux`.
```
[orealyz@db ~]$ sudo dnf install epel-release -y
[sudo] password for orealyz:
Last metadata expiration check: 0:07:15 ago on Mon 16 Jan 2023 10:54:36 AM CET.
Package epel-release-9-4.el9.noarch is already installed.
Dependencies resolved.
Nothing to do.
Complete!
```
```
[orealyz@db ~]$ wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh
```
```
[orealyz@db ~]$ sudo systemctl start netdata
[orealyz@db ~]$ sudo systemctl enable netdata
[orealyz@db ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; >
     Active: active (running) since Mon 2023-01-16 11:04:05 CET; 34s ago
   Main PID: 13143 (netdata)
      Tasks: 76 (limit: 5905)
     Memory: 125.4M
        CPU: 1.676s
     CGroup: /system.slice/netdata.service
             ├─13143 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
             ├─13146 /usr/sbin/netdata --special-spawn-server
             ├─13349 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.>
             ├─13362 /usr/libexec/netdata/plugins.d/apps.plugin 1
             ├─13364 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
             └─13365 /usr/libexec/netdata/plugins.d/go.d.plugin 1
```
```
[orealyz@db ~]$ sudo firewall-cmd --permanent --add-port=19999/tcp
success
[orealyz@db ~]$ sudo firewall-cmd --reload
success
[orealyz@db ~]$ sudo firewall-cmd --list-all | grep port
  ports: 19999/tcp
  forward-ports:
  source-ports:
```
```
[orealyz@web ~]$ sudo ss -ltunp | grep netdata
udp   UNCONN 0      0          127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=1661,fd=39))

udp   UNCONN 0      0              [::1]:8125          [::]:*    users:(("netdata",pid=1661,fd=38))

tcp   LISTEN 0      4096       127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=1661,fd=41))

tcp   LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*    users:(("netdata",pid=1661,fd=6))

tcp   LISTEN 0      4096           [::1]:8125          [::]:*    users:(("netdata",pid=1661,fd=40))

tcp   LISTEN 0      4096            [::]:19999         [::]:*    users:(("netdata",pid=1661,fd=7))
```



➜ **Une fois en place**, Netdata déploie une interface un Web pour avoir moult stats en temps réel, utilisez une commande `ss` pour repérer sur quel port il tourne.

Utilisez votre navigateur pour visiter l'interface web de Netdata `http://<IP_VM>:<PORT_NETDATA>`.

🌞 **Une fois Netdata installé et fonctionnel, déterminer :**

- l'utilisateur sous lequel tourne le(s) processus Netdata
- si Netdata écoute sur des ports
- comment sont consultables les logs de Netdata
```
[orealyz@web ~]$ ps -aux | grep netdata
netdata     1661  0.5  6.1 463936 48348 ?        SNsl 11:14   0:02 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
netdata     1663  0.0  1.2  28736 10176 ?        SNl  11:14   0:00 /usr/sbin/netdata --special-spawn-server
netdata     1873  0.0  0.4   4504  3500 ?        SN   11:14   0:00 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
netdata     1886  0.4  0.7 134424  6080 ?        SNl  11:14   0:01 /usr/libexec/netdata/plugins.d/apps.plugin 1
root        1887  0.1  4.0 740992 31372 ?        SNl  11:14   0:00 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
netdata     1888  0.1  6.3 773668 49968 ?        SNl  11:14   0:00 /usr/libexec/netdata/plugins.d/go.d.plugin 1
orealyz     2287  0.0  0.2   6408  2136 pts/0    S+   11:20   0:00 grep --color=auto netdata
```
```
[orealyz@web ~]$ sudo firewall-cmd --list-all | grep port
[sudo] password for orealyz:
  ports: 80/tcp 19999/tcp
  forward-ports:
  source-ports:
```
```
[orealyz@web ~]$ sudo journalctl -u netdata | tail -n 10
Jan 16 11:14:25 web.tb6.linux systemd[1]: Starting Real time performance monitoring...
Jan 16 11:14:25 web.tb6.linux systemd[1]: Started Real time performance monitoring.
Jan 16 11:14:25 web.tb6.linux netdata[1661]: CONFIG: cannot load cloud config '/var/lib/netdata/cloud.d/cloud.conf'. Running with internal defaults.
Jan 16 11:14:25 web.tb6.linux netdata[1661]: 2023-01-16 11:14:25: netdata INFO  : MAIN : CONFIG: cannot load cloud config '/var/lib/netdata/cloud.d/cloud.conf'. Running with internal defaults.
Jan 16 11:14:25 web.tb6.linux netdata[1661]: Found 0 legacy dbengines, setting multidb diskspace to 256MB
Jan 16 11:14:25 web.tb6.linux netdata[1661]: 2023-01-16 11:14:25: netdata INFO  : MAIN : Found 0 legacy dbengines, setting multidb diskspace to 256MB
Jan 16 11:14:25 web.tb6.linux netdata[1661]: Created file '/var/lib/netdata/dbengine_multihost_size' to store the computed value
Jan 16 11:14:25 web.tb6.linux netdata[1661]: 2023-01-16 11:14:25: netdata INFO  : MAIN : Created file '/var/lib/netdata/dbengine_multihost_size' to store the computed value
Jan 16 11:14:30 web.tb6.linux ebpf.plugin[1887]: Does not have a configuration file inside `/etc/netdata/ebpf.d.conf. It will try to load stock file.
Jan 16 11:14:30 web.tb6.linux ebpf.plugin[1887]: Cannot read process groups configuration file '/etc/netdata/apps_groups.conf'. Will try '/usr/lib/netdata/conf.d/apps_groups.conf'
```
➜ **Vous ne devez PAS utiliser le "Cloud Netdata"**

- lorsque vous accéder à l'interface web de Netdata :
  - vous NE DEVEZ PAS être sur une URL `netdata.cloud`
  - vous DEVEZ visiter l'interface en saisissant l'IP de votre serveur
- l'interface Web tourne surle port 19999 par défaut

🌞 **Configurer Netdata pour qu'il vous envoie des alertes** 

- dans [un salon Discord](https://learn.netdata.cloud/docs/agent/health/notifications/discord) dédié en cas de soucis

🌞 **Vérifier que les alertes fonctionnent**

- en surchargeant volontairement la machine 
- par exemple, effectuez des *stress tests* de RAM et CPU, ou remplissez le disque volontairement
- demandez au grand Internet comme on peut "stress" une machine (c'est le terme technique)

![Monitoring](../pics/monit.jpg)