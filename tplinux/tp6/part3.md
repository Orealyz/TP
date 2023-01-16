# Module 3 : Fail2Ban

🌞 Faites en sorte que :

```
[orealyz@db ~]$ sudo systemctl start firewalld
[orealyz@db ~]$ sudo systemctl enable firewalld
[orealyz@db ~]$ sudo systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled>
     Active: active (running) since Mon 2023-01-16 10:14:58 CET; 3min 9>
       Docs: man:firewalld(1)
   Main PID: 644 (firewalld)
      Tasks: 2 (limit: 5905)
     Memory: 41.8M
        CPU: 287ms
     CGroup: /system.slice/firewalld.service
             └─644 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --n>
```
```
sudo firewall-cmsudo firewall-cmd --list-all
[orealyz@db ~]$  sudo dnf install epel-release
[orealyz@db ~]$  sudo dnf install fail2ban fail2ban-firewalld
```
```
[orealyz@db ~]$ sudo systemctl start fail2ban
[orealyz@db ~]$ sudo systemctl enable fail2ban
Created symlink /etc/systemd/system/multi-user.target.wants/fail2ban.service → /usr/lib/systemd/system/fail2ban.service.
[orealyz@db ~]$ sudo systemctl status fail2ban
● fail2ban.service - Fail2Ban Service
     Loaded: loaded (/usr/lib/systemd/system/fail2ban.service; enabled;>
     Active: active (running) since Mon 2023-01-16 10:21:38 CET; 8s ago
       Docs: man:fail2ban(1)
   Main PID: 12342 (fail2ban-server)
      Tasks: 3 (limit: 5905)
     Memory: 10.3M
        CPU: 58ms
     CGroup: /system.slice/fail2ban.service
             └─12342 /usr/bin/python3 -s /usr/bin/fail2ban-server -xf s>

Jan 16 10:21:38 db.tp6.linux systemd[1]: Starting Fail2Ban Service...
Jan 16 10:21:38 db.tp6.linux systemd[1]: Started Fail2Ban Service.
Jan 16 10:21:38 db.tp6.linux fail2ban-server[12342]: 2023-01-16 10:21:3>
Jan 16 10:21:39 db.tp6.linux fail2ban-server[12342]: Server ready
```
```
[orealyz@db ~]$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
```
[orealyz@db ~]$ sudo mv /etc/fail2ban/jail.d/00-firewalld.conf /etc/fail2ban/jail.d/00-firewalld.local
```
```
sudo systemctl restart fail2ban
```
```
[orealyz@db ~]$ sudo cat /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true

# Override the default global configuration
# for specific jail sshd
bantime = 1d
findtime = 1min
maxretry = 3
```
```
[orealyz@db ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     3
|  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   10.105.1.11
```
```
[orealyz@db ~]$ sudo firewall-cmd --list-all | grep ssh
  services: cockpit dhcpv6-client ssh
        rule family="ipv4" source address="10.105.1.11" port port="ssh" protocol="tcp" reject type="icmp-port-unreachable"
```
```
[orealyz@db ~]$ sudo fail2ban-client unban 10.105.1.11
1
[orealyz@db ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     3
|  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned: 0
   |- Total banned:     1
   `- Banned IP list:
```
Pour la partie 4, it's here -> [part4](part4.md)