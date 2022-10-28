# TP3 : On va router des trucs

Au menu de ce TP, on va revoir un peu ARP et IP histoire de **se mettre en jambes dans un environnement avec des VMs**.

Puis on mettra en place **un routage simple, pour permettre à deux LANs de communiquer**.

![Reboot the router](./pics/reboot.jpeg)

## Sommaire

- [TP3 : On va router des trucs](#tp3--on-va-router-des-trucs)
  - [Sommaire](#sommaire)
  - [0. Prérequis](#0-prérequis)
  - [I. ARP](#i-arp)
    - [1. Echange ARP](#1-echange-arp)
    - [2. Analyse de trames](#2-analyse-de-trames)
  - [II. Routage](#ii-routage)
    - [1. Mise en place du routage](#1-mise-en-place-du-routage)
    - [2. Analyse de trames](#2-analyse-de-trames-1)
    - [3. Accès internet](#3-accès-internet)
  - [III. DHCP](#iii-dhcp)
    - [1. Mise en place du serveur DHCP](#1-mise-en-place-du-serveur-dhcp)
    - [2. Analyse de trames](#2-analyse-de-trames-2)

## 0. Prérequis

➜ Pour ce TP, on va se servir de VMs Rocky Linux. 1Go RAM c'est large large. Vous pouvez redescendre la mémoire vidéo aussi.  

➜ Vous aurez besoin de deux réseaux host-only dans VirtualBox :

- un premier réseau `10.3.1.0/24`
- le second `10.3.2.0/24`
- **vous devrez désactiver le DHCP de votre hyperviseur (VirtualBox) et définir les IPs de vos VMs de façon statique**

➜ Les firewalls de vos VMs doivent **toujours** être actifs (et donc correctement configurés).

➜ **Si vous voyez le p'tit pote 🦈 c'est qu'il y a un PCAP à produire et à mettre dans votre dépôt git de rendu.**

## I. ARP

Première partie simple, on va avoir besoin de 2 VMs.

| Machine  | `10.3.1.0/24` |
|----------|---------------|
| `john`   | `10.3.1.11`   |
| `marcel` | `10.3.1.12`   |

```schema
   john               marcel
  ┌─────┐             ┌─────┐
  │     │    ┌───┐    │     │
  │     ├────┤ho1├────┤     │
  └─────┘    └───┘    └─────┘
```

> Référez-vous au [mémo Réseau Rocky](../../cours/memo/rocky_network.md) pour connaître les commandes nécessaire à la réalisation de cette partie.

### 1. Echange ARP

🌞**Générer des requêtes ARP**

- effectuer un `ping` d'une machine à l'autre
```
[orealyz@john ~]$ ping 10.3.1.12
PING 10.3.1.12 (10.3.1.12) 56(84) bytes of data.
64 bytes from 10.3.1.12: icmp_seq=1 ttl=64 time=1.64 ms
64 bytes from 10.3.1.12: icmp_seq=2 ttl=64 time=1.02 ms
64 bytes from 10.3.1.12: icmp_seq=3 ttl=64 time=0.877 ms
64 bytes from 10.3.1.12: icmp_seq=4 ttl=64 time=1.02 ms
64 bytes from 10.3.1.12: icmp_seq=5 ttl=64 time=0.678 ms
64 bytes from 10.3.1.12: icmp_seq=6 ttl=64 time=0.879 ms
64 bytes from 10.3.1.12: icmp_seq=7 ttl=64 time=0.753 ms
64 bytes from 10.3.1.12: icmp_seq=8 ttl=64 time=0.877 ms
64 bytes from 10.3.1.12: icmp_seq=9 ttl=64 time=0.772 ms
64 bytes from 10.3.1.12: icmp_seq=10 ttl=64 time=0.891 ms
^C
--- 10.3.1.12 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9131ms
rtt min/avg/max/mdev = 0.678/0.940/1.641/0.254 ms

```
- observer les tables ARP des deux machines 
 ```
[orealyz@john ~]$ ip neigh show
10.3.1.12 dev enp0s8 lladdr 08:00:27:79:38:99 STALE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:3e DELAY

```
```
[orealyz@marcel ~]$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:3e REACHABLE
10.3.1.11 dev enp0s8 lladdr 08:00:27:23:56:57 STALE

```
- repérer l'adresse MAC de `john` dans la table ARP de `marcel` 
```
10.3.1.11 dev enp0s8 lladdr 08:00:27:23:56:57 STALE
```
et vice-versa
```
10.3.1.12 dev enp0s8 lladdr 08:00:27:79:38:99 STALE

```

- prouvez que l'info est correcte (que l'adresse MAC que vous voyez dans la table est bien celle de la machine correspondante)
  - une commande pour voir la MAC de `marcel` dans la table ARP de `john`
 ```
  [orealyz@john ~]$ ip neigh show 10.3.1.12
10.3.1.12 dev enp0s8 lladdr 08:00:27:79:38:99 REACHABLE
```
  - et une commande pour afficher la MAC de `marcel`, depuis `marcel`
 ```
  [orealyz@marcel ~]$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:0e DELAY
10.3.1.11 dev enp0s8 lladdr 08:00:27:23:56:57 STALE
```

### 2. Analyse de trames

🌞**Analyse de trames**

- utilisez la commande `tcpdump` pour réaliser une capture de trame
```
[orealyz@john ~]$ sudo tcpdump -i enp0s8 -c 5
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp0s8, link-type EN10MB (Ethernet), snapshot length 262144 bytes
09:36:45.663640 IP john.ssh > 10.3.1.1.50349: Flags [P.], seq 1076341243:1076341303, ack 3387798939, win 501, length 60
09:36:45.663766 IP john.ssh > 10.3.1.1.50349: Flags [P.], seq 60:204, ack 1, win 501, length 144
09:36:45.663901 IP 10.3.1.1.50349 > john.ssh: Flags [.], ack 60, win 8209, length 0
09:36:45.663952 IP john.ssh > 10.3.1.1.50349: Flags [P.], seq 204:240, ack 1, win 501, length 36
09:36:45.663977 IP john.ssh > 10.3.1.1.50349: Flags [P.], seq 240:300, ack 1, win 501, length 60
5 packets captured
17 packets received by filter
0 packets dropped by kernel

```
- videz vos tables ARP, sur les deux machines, puis effectuez un `ping`
```
[orealyz@john ~]$ sudo ip neigh flush all
[orealyz@marcel ~]$ sudo ip neigh flush all
```

🦈 **Capture réseau `tp3_arp.pcapng`** qui contient un ARP request et un ARP reply
[arp](https://github.com/Orealyz/TP/blob/main/tp3/tp3%20arp%20sp%C3%A9cifique.pcap)

> **Si vous ne savez pas comment récupérer votre fichier `.pcapng`** sur votre hôte afin de l'ouvrir dans Wireshark, et me le livrer en rendu, demandez-moi.

## II. Routage

Vous aurez besoin de 3 VMs pour cette partie. **Réutilisez les deux VMs précédentes.**

| Machine  | `10.3.1.0/24` | `10.3.2.0/24` |
|----------|---------------|---------------|
| `router` | `10.3.1.254`  | `10.3.2.254`  |
| `john`   | `10.3.1.11`   | no            |
| `marcel` | no            | `10.3.2.12`   |

> Je les appelés `marcel` et `john` PASKON EN A MAR des noms nuls en réseau 🌻

```schema
   john                router              marcel
  ┌─────┐             ┌─────┐             ┌─────┐
  │     │    ┌───┐    │     │    ┌───┐    │     │
  │     ├────┤ho1├────┤     ├────┤ho2├────┤     │
  └─────┘    └───┘    └─────┘    └───┘    └─────┘
```

### 1. Mise en place du routage

🌞**Activer le routage sur le noeud `router`**

> Cette étape est nécessaire car Rocky Linux c'est pas un OS dédié au routage par défaut. Ce n'est bien évidemment une opération qui n'est pas nécessaire sur un équipement routeur dédié comme du matériel Cisco.
```
[orealyz@router ~]$ sudo firewall-cmd --add-masquerade --zone=public --permanent
[sudo] password for orealyz:
success
```

🌞**Ajouter les routes statiques nécessaires pour que `john` et `marcel` puissent se `ping`**
- il faut taper une commande `ip route add` pour cela, voir mémo
```
[orealyz@john ~]$ sudo ip route add default via 10.3.1.254 dev enp0s8

[orealyz@john ~]$ ip route
default via 10.3.1.254 dev enp0s8
10.3.1.0/24 dev enp0s8 proto kernel scope link src 10.3.1.11 metric 100

```
- il faut ajouter une seule route des deux côtés
- une fois les routes en place, vérifiez avec un `ping` que les deux machines peuvent se joindre
 ```
 
[orealyz@john ~]$ ping 10.3.2.12
PING 10.3.2.12 (10.3.2.12) 56(84) bytes of data.
64 bytes from 10.3.2.12: icmp_seq=1 ttl=63 time=2.26 ms
64 bytes from 10.3.2.12: icmp_seq=2 ttl=63 time=2.00 ms
64 bytes from 10.3.2.12: icmp_seq=3 ttl=63 time=1.98 ms
64 bytes from 10.3.2.12: icmp_seq=4 ttl=63 time=1.12 ms
^C
--- 10.3.2.12 ping statistics ---
[orealyz@marcel ~]$ ping 10.3.1.11
PING 10.3.1.11 (10.3.1.11) 56(84) bytes of data.
64 bytes from 10.3.1.11: icmp_seq=1 ttl=63 time=1.70 ms
64 bytes from 10.3.1.11: icmp_seq=2 ttl=63 time=1.84 ms
64 bytes from 10.3.1.11: icmp_seq=3 ttl=63 time=1.94 ms
^C
--- 10.3.1.11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.702/1.825/1.938/0.096 ms


 ```
![THE SIZE](./pics/thesize.png)

### 2. Analyse de trames

🌞**Analyse des échanges ARP**

- videz les tables ARP des trois noeuds
```
[orealyz@router ~]$ sudo ip neigh flush all
[sudo] password for orealyz:
[orealyz@john ~]$ sudo ip neigh flush all
[sudo] password for orealyz:
[orealyz@marcel ~]$ sudo ip neigh flush all
[sudo] password for orealyz:
```
- effectuez un `ping` de `john` vers `marcel`
```
[orealyz@john ~]$ sudo tcpdump -i enp0s8 -w arp_john.pcapng
[sudo] password for orealyz:
dropped privs to tcpdump
tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), snapshot length 262144 bytes
ping 10.3.2.12
^C61 packets captured
62 packets received by filter
0 packets dropped by kernel
```
[arp_john](https://github.com/Orealyz/TP/blob/main/tp3/tp3_arp_john.pcap)
- regardez les tables ARP des trois noeuds
- essayez de déduire un peu les échanges ARP qui ont eu lieu
- répétez l'opération précédente (vider les tables, puis `ping`), en lançant `tcpdump` sur `marcel`
```
[orealyz@marcel ~]$ sudo ip neigh flush all
```
[arp_marcel](https://github.com/Orealyz/TP/blob/main/tp3/tp3_routage_marcel1.pcapng.pcap)

- **écrivez, dans l'ordre, les échanges ARP qui ont eu lieu, puis le ping et le pong, je veux TOUTES les trames** utiles pour l'échange

Par exemple (copiez-collez ce tableau ce sera le plus simple) :

| ordre | type trame  | IP source | MAC source              | IP destination | MAC destination            |
|-------|-------------|-----------|-------------------------|----------------|----------------------------|
| 1     | Requête ARP | 10.3.1.11         |`john` `08:00:27:23:56:57`| 10.3.1.254  | Broadcast `FF:FF:FF:FF:FF` |
| 2     | Réponse ARP | 10.3.1.254        | `routeur` `08:00:27:fa:cd:6d`  | 10.3.1.11             | `john` `08:00:27:23:56:57`  |
| 3     | Ping         | 10.3.1.11       | `john` `08:00:27:23:56:57`  |   10.3.2.12              |`routeur` `08:00:27:fa:cd:6d` |
| 4     | ARP        | 10.3.2.254      | `routeur` `08:00:27:fa:cd:6d`  |        x        |   Broadcast `FF:FF:FF:FF:FF`  |
| 5     | ARP         | 10.3.2.12      |`marcel` `08:00:27:79:38:99`| 10.3.2.254           |   `routeur` `08:00:27:fa:cd:6d` |
| 6     | Ping        | 10.3.2.254      |`routeur` `08:00:27:fa:cd:6d`| 10.3.2.12  | `marcel` `08:00:27:79:38:99` |
| 7     | Pong        | 10.3.2.12      |`marcel` `08:00:27:79:38:99`| 10.3.2.254           |   `routeur` `08:00:27:fa:cd:6d` |
| 8     | Pong        | 10.3.2.12      |`marcel` `08:00:27:79:38:99`| 10.3.1.11       | `john` `08:00:27:23:56:57`  |

> Vous pourriez, par curiosité, lancer la capture sur `john` aussi, pour voir l'échange qu'il a effectué de son côté.

🦈 **Capture réseau `tp3_routage_marcel.pcapng`**

### 3. Accès internet

🌞**Donnez un accès internet à vos machines**

- ajoutez une carte NAT en 3ème inteface sur le `router` pour qu'il ait un accès internet
- ajoutez une route par défaut à `john` et `marcel`
  - vérifiez que vous avez accès internet avec un `ping`

  - le `ping` doit être vers une IP, PAS un nom de domaine
```
[orealyz@john ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=112 time=23.1 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=112 time=22.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=112 time=23.3 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 22.716/23.047/23.312/0.247 ms
```
- donnez leur aussi l'adresse d'un serveur DNS qu'ils peuvent utiliser
```
[orealyz@marcel ~]$ cat /etc/resolv.conf
# Generated by NetworkManager
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
```
  - vérifiez que vous avez une résolution de noms qui fonctionne avec `dig`
  ```
  [orealyz@marcel ~]$ dig google.com

; <<>> DiG 9.16.23-RH <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58805
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             195     IN      A       142.250.75.238

;; Query time: 25 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Fri Oct 28 11:10:23 CEST 2022
;; MSG SIZE  rcvd: 55
```
  - puis avec un `ping` vers un nom de domaine
  ```
  [orealyz@marcel ~]$ ping google.com
PING google.com (142.250.179.78) 56(84) bytes of data.
64 bytes from par21s19-in-f14.1e100.net (142.250.179.78): icmp_seq=1 ttl=112 time=25.4 ms
64 bytes from par21s19-in-f14.1e100.net (142.250.179.78): icmp_seq=2 ttl=112 time=25.1 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 25.094/25.247/25.401/0.153 ms
```
🌞**Analyse de trames**

- effectuez un `ping 8.8.8.8` depuis `john`
```
[orealyz@john ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=112 time=23.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=112 time=26.2 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 23.779/24.978/26.177/1.199 ms
```
- capturez le ping depuis `john` avec `tcpdump`
[tp3_routage_internet.pcapng](https://github.com/Orealyz/TP/blob/main/tp3/8.8.8.8_john1.pcap)
- analysez un ping aller et le retour qui correspond et mettez dans un tableau :

| ordre | type trame | IP source          | MAC source              | IP destination | MAC destination |     |
|-------|------------|--------------------|-------------------------|----------------|-----------------|-----|
| 1     | ping       | `john` `10.3.1.11` | `john` `08:00:27:23:56:57` | `8.8.8.8`      |`08:00:27:fa:cd:6d`               |     |
| 2     | pong       |`8.8.8.8`                | `08:00:27:fa:cd:6d`                    | `10.3.1.11`          |         `08:00:27:23:56:57`    |

🦈 **Capture réseau `tp3_routage_internet.pcapng`**

## III. DHCP

On reprend la config précédente, et on ajoutera à la fin de cette partie une 4ème machine pour effectuer des tests.

| Machine  | `10.3.1.0/24`              | `10.3.2.0/24` |
|----------|----------------------------|---------------|
| `router` | `10.3.1.254`               | `10.3.2.254`  |
| `john`   | `10.3.1.11`                | no            |
| `bob`    | oui mais pas d'IP statique | no            |
| `marcel` | no                         | `10.3.2.12`   |

```schema
   john               router              marcel
  ┌─────┐             ┌─────┐             ┌─────┐
  │     │    ┌───┐    │     │    ┌───┐    │     │
  │     ├────┤ho1├────┤     ├────┤ho2├────┤     │
  └─────┘    └─┬─┘    └─────┘    └───┘    └─────┘
   dhcp        │
  ┌─────┐      │
  │     │      │
  │     ├──────┘
  └─────┘
```

### 1. Mise en place du serveur DHCP

🌞**Sur la machine `john`, vous installerez et configurerez un serveur DHCP** (go Google "rocky linux dhcp server").

- installation du serveur sur `john`
```
[orealyz@john dhcp]$ sudo nano dhcpd.conf
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#

default-lease-time 900;
max-lease-time 10800;
ddns-update-style none;
authoritative;
subnet 10.3.1.0 netmask 255.255.255.0 {
        range 10.3.1.3 10.3.1.252;
}


```
- créer une machine `bob`

- faites lui récupérer une IP en DHCP à l'aide de votre serveur

> Il est possible d'utilise la commande `dhclient` pour forcer à la main, depuis la ligne de commande, la demande d'une IP en DHCP, ou renouveler complètement l'échange DHCP (voir `dhclient -h` puis call me et/ou Google si besoin d'aide).

🌞**Améliorer la configuration du DHCP**

- ajoutez de la configuration à votre DHCP pour qu'il donne aux clients, en plus de leur IP : 
  - une route par défaut
  - un serveur DNS à utiliser
```
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#

default-lease-time 900;
max-lease-time 10800;
ddns-update-style none;
authoritative;
subnet 10.3.1.0 netmask 255.255.255.0 {
        range 10.3.1.3 10.3.1.252;
        option routers 10.3.1.254;
        option domain-name-servers 1.1.1.1;
}

```
- récupérez de nouveau une IP en DHCP sur `bob` pour tester :
  - `bob` doit avoir une IP
    - vérifier avec une commande qu'il a récupéré son IP
```
    [orealyz@localhost ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:aa:8d:dc brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.3/24 brd 10.3.1.255 scope global dynamic noprefixroute enp0s8
       valid_lft 892sec preferred_lft 892sec
    inet6 fe80::a00:27ff:feaa:8ddc/64 scope link
       valid_lft forever preferred_lft forever
```
  
  - vérifier qu'il peut `ping` sa passerelle
  ```
    [orealyz@localhost ~]$ ping 10.3.1.254
PING 10.3.1.254 (10.3.1.254) 56(84) bytes of data.
64 bytes from 10.3.1.254: icmp_seq=1 ttl=64 time=0.423 ms
64 bytes from 10.3.1.254: icmp_seq=2 ttl=64 time=0.387 ms
^C
--- 10.3.1.254 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1010ms
rtt min/avg/max/mdev = 0.387/0.405/0.423/0.018 ms
```
  - il doit avoir une route par défaut
    - vérifier la présence de la route avec une commande
```
    [orealyz@localhost ~]$ ip r s
default via 10.3.1.254 dev enp0s8 proto dhcp src 10.3.1.3 metric 100
10.3.1.0/24 dev enp0s8 proto kernel scope link src 10.3.1.3 metric 100
```

   - vérifier que la route fonctionne avec un `ping` vers une IP
```
  [orealyz@localhost ~]$ ping 10.3.2.12
PING 10.3.2.12 (10.3.2.12) 56(84) bytes of data.
64 bytes from 10.3.2.12: icmp_seq=1 ttl=63 time=0.672 ms
64 bytes from 10.3.2.12: icmp_seq=2 ttl=63 time=0.636 ms
^C
--- 10.3.2.12 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1011ms
rtt min/avg/max/mdev = 0.636/0.654/0.672/0.018 ms
```
    
  - il doit connaître l'adresse d'un serveur DNS pour avoir de la résolution de noms
    - vérifier avec la commande `dig` que ça fonctionne
```
    [orealyz@localhost ~]$ dig google.com
; <<>> DiG 9.16.23-RH <<>> gitlab.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 33526
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;gitlab.com.                    IN      A

;; ANSWER SECTION:
gitlab.com.             144     IN      A       172.65.251.78

;; Query time: 35 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Thu Oct 13 15:47:40 CEST 2022
;; MSG SIZE  rcvd: 55
```
    - vérifier un `ping` vers un nom de domaine
```
[orealyz@localhost ~]$ ping google.com
PING google.com (216.58.206.238) 56(84) bytes of data.
64 bytes from par10s34-in-f14.1e100.net (216.58.206.238): icmp_seq=1 ttl=61 time=28.0 ms
64 bytes from par10s34-in-f14.1e100.net (216.58.206.238): icmp_seq=2 ttl=61 time=46.0 ms
### 2. Analyse de trames
```
🌞**Analyse de trames**

- lancer une capture à l'aide de `tcpdump` afin de capturer un échange DHCP
- demander une nouvelle IP afin de générer un échange DHCP
- exportez le fichier `.pcapng`

🦈 **Capture réseau `tp3_dhcp.pcapng`**
[dhcp](https://github.com/Orealyz/TP/blob/main/tp3/tp3_capture_dhcp.pcapng)