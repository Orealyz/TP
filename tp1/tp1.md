
# I. Exploration locale en solo

## 1. Affichage d'informations sur la pile TCP/IP locale

### En ligne de commande

En utilisant la ligne de commande (CLI) de votre OS :

**🌞 Affichez les infos des cartes réseau de votre PC**
```
PS C:\Users\b> ipconfig /all
```
- nom, adresse MAC et adresse IP de l'interface WiFi
``` 
PS C:\Users\b> ipconfig /all
Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 20-1E-88-3A-B3-35
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::44ee:38cd:6e94:79af%18(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.16.172(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : lundi 3 octobre 2022 08:54:39
   Bail expirant. . . . . . . . . . . . . : mardi 4 octobre 2022 08:54:18
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   Serveur DHCP . . . . . . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 253763208
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-5A-6F-F9-B0-25-AA-47-C7-A4
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
                                       1.1.1.1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```
- nom, adresse MAC et adresse IP de l'interface Ethernet
 ``` 
 PS C:\Users\b> ipconfig /all
Carte Ethernet Ethernet :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . : digitechnic.local
   Description. . . . . . . . . . . . . . : Intel(R) Ethernet Controller (3) I225-V
   Adresse physique . . . . . . . . . . . : B0-25-AA-47-C7-A4
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : OuiIP n'étant pas connecté en ethernet 
 ```

**🌞 Affichez votre gateway**

- utilisez une commande pour connaître l'adresse IP de la passerelle (ou *gateway*) de votre carte WiFi
```
PS C:\Users\b> ipconfig /all
Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 20-1E-88-3A-B3-35
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::44ee:38cd:6e94:79af%18(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.16.172(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : lundi 3 octobre 2022 08:54:39
   Bail expirant. . . . . . . . . . . . . : mardi 4 octobre 2022 08:54:18
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   Serveur DHCP . . . . . . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 253763208
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-5A-6F-F9-B0-25-AA-47-C7-A4
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
                                       1.1.1.1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```

**🌞 Déterminer la MAC de la passerelle**

- à l'aide d'une commande, affichez votre table ARP, et déterminez ainsi l'adresse MAC de la passerelle
```
PS C:\Users\b> arp -a
Interface : 192.168.56.1 --- 0x6
  Adresse Internet      Adresse physique      Type
  192.168.56.255        ff-ff-ff-ff-ff-ff     statique
  224.0.0.0             01-00-5e-00-00-00     statique
  224.0.0.22            01-00-5e-00-00-16     statique
  224.0.0.251           01-00-5e-00-00-fb     statique
  224.0.0.252           01-00-5e-00-00-fc     statique
  239.255.255.250       01-00-5e-7f-ff-fa     statique
  255.255.255.255       ff-ff-ff-ff-ff-ff     statique

Interface : 192.168.77.1 --- 0xe
  Adresse Internet      Adresse physique      Type
  192.168.77.254        00-50-56-fd-1b-f2     dynamique
  192.168.77.255        ff-ff-ff-ff-ff-ff     statique
  224.0.0.0             01-00-5e-00-00-00     statique
  224.0.0.22            01-00-5e-00-00-16     statique
  224.0.0.251           01-00-5e-00-00-fb     statique
  224.0.0.252           01-00-5e-00-00-fc     statique
  239.255.255.250       01-00-5e-7f-ff-fa     statique
  255.255.255.255       ff-ff-ff-ff-ff-ff     statique

Interface : 192.168.232.1 --- 0x11
  Adresse Internet      Adresse physique      Type
  192.168.232.254       00-50-56-fb-72-c4     dynamique
  192.168.232.255       ff-ff-ff-ff-ff-ff     statique
  224.0.0.0             01-00-5e-00-00-00     statique
  224.0.0.22            01-00-5e-00-00-16     statique
  224.0.0.251           01-00-5e-00-00-fb     statique
  224.0.0.252           01-00-5e-00-00-fc     statique
  239.255.255.250       01-00-5e-7f-ff-fa     statique
  255.255.255.255       ff-ff-ff-ff-ff-ff     statique

Interface : 10.33.16.172 --- 0x12
  Adresse Internet      Adresse physique      Type
  10.33.18.241          3c-a9-f4-94-b2-8c     dynamique
  10.33.18.249          d0-c6-37-41-0a-9b     dynamique
  10.33.18.250          04-ea-56-37-f3-93     dynamique
  10.33.19.183          7c-5c-f8-1e-ce-b3     dynamique
  10.33.19.254          00-c0-e7-e0-04-4e     dynamique
  10.33.19.255          ff-ff-ff-ff-ff-ff     statique
  224.0.0.0             01-00-5e-00-00-00     statique
  224.0.0.22            01-00-5e-00-00-16     statique
  224.0.0.251           01-00-5e-00-00-fb     statique
  224.0.0.252           01-00-5e-00-00-fc     statique
  239.255.255.250       01-00-5e-7f-ff-fa     statique
  255.255.255.255       ff-ff-ff-ff-ff-ff     statique
PS C:\Users\b> ipconfig /all
```


### En graphique (GUI : Graphical User Interface)

En utilisant l'interface graphique de votre OS :  

**🌞 Trouvez comment afficher les informations sur une carte IP (change selon l'OS)**

- trouvez l'IP, la MAC et la gateway pour l'interface WiFi de votre PC

![](https://i.imgur.com/jnmDkFf.png)


## 2. Modifications des informations

### A. Modification d'adresse IP (part 1)  

🌞 Utilisez l'interface graphique de votre OS pour **changer d'adresse IP** :

- changez l'adresse IP de votre carte WiFi pour une autre
- ne changez que le dernier octet
 ```
PS C:\Users\b> ipconfig /a
 
Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 20-1E-88-3A-B3-35
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::44ee:38cd:6e94:79af%18(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.16.250(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 253763208
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-5A-6F-F9-B0-25-AA-47-C7-A4
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

 ```
 

🌞 **Il est possible que vous perdiez l'accès internet.** Que ce soit le cas ou non, expliquez pourquoi c'est possible de perdre son accès internet en faisant cette opération.

--- Si quelqu'un a la meme adresse ip que nous, l'adresse ip attribué en premiere sera prioritaire.

# II. Exploration locale en duo

Owkay. Vous savez à ce stade :

- afficher les informations IP de votre machine
- modifier les informations IP de votre machine
- c'est un premier pas vers la maîtrise de votre outil de travail

On va maintenant répéter un peu ces opérations, mais en créant un réseau local de toutes pièces : entre deux PCs connectés avec un câble RJ45.

## 1. Prérequis

- deux PCs avec ports RJ45
- un câble RJ45
- **firewalls désactivés** sur les deux PCs

## 2. Câblage

Ok c'est la partie tendue. Prenez un câble. Branchez-le des deux côtés. **Bap.**

## Création du réseau (oupa)

Cette étape pourrait paraître cruciale. En réalité, elle n'existe pas à proprement parlé. On ne peut pas "créer" un réseau.

**Si une machine possède une carte réseau, et si cette carte réseau porte une adresse IP**, alors cette adresse IP se trouve dans un réseau (l'adresse de réseau). Ainsi, **le réseau existe. De fait.**  

**Donc il suffit juste de définir une adresse IP sur une carte réseau pour que le réseau existe ! Bap.**

## 3. Modification d'adresse IP

🌞 **Modifiez l'IP des deux machines pour qu'elles soient dans le même réseau**

- Si vos PCs ont un port RJ45 alors y'a une carte réseau Ethernet associée
- choisissez une IP qui commence par "10.10.10."
  - /24 pour la longueur de masque, ou 255.255.255.0 pour le masque (suivant les OS, l'info est demandée différement, mais c'est la même chose)
![](https://i.imgur.com/mmOGZG1.png)

🌞 **Vérifier à l'aide d'une commande que votre IP a bien été changée**
``` PS C:\Users\b> ipconfig /all
Carte Ethernet Ethernet :

   Suffixe DNS propre à la connexion. . . : digitechnic.local
   Description. . . . . . . . . . . . . . : Intel(R) Ethernet Controller (3) I225-V
   Adresse physique . . . . . . . . . . . : B0-25-AA-47-C7-A4
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::142a:7980:caa9:8be4%10(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.10.10.250(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 632300970
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-5A-6F-F9-B0-25-AA-47-C7-A4
   Serveurs DNS. . .  . . . . . . . . . . : 192.168.100.90
                                       192.168.100.72
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
   ```


🌞 **Vérifier que les deux machines se joignent**

- utilisez la commande `ping` pour tester la connectivité entre les deux machines

```
PS C:\Users\b> ping  10.10.10.251
Envoi d’une requête 'Ping'  10.10.10.251 avec 32 octets de données :
Réponse de 10.10.10.251 : octets=32 temps=84 ms TTL=128
Réponse de 10.10.10.251 : octets=32 temps=2 ms TTL=128
Réponse de 10.10.10.251 : octets=32 temps=1 ms TTL=128
Réponse de 10.10.10.251 : octets=32 temps=1 ms TTL=128

Statistiques Ping pour 10.10.10.251:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 84ms, Moyenne = 22ms
```


🌞 **Déterminer l'adresse MAC de votre correspondant**

- pour cela, affichez votre table ARP
```
PS C:\Users\b> arp -a
Interface : 10.10.10.250 --- 0xa
  Adresse Internet      Adresse physique      Type
  10.10.10.251          c0-18-03-59-30-32     dynamique
  10.10.10.255          ff-ff-ff-ff-ff-ff     statique
  169.254.225.125       c0-18-03-59-30-32     dynamique
  224.0.0.0             01-00-5e-00-00-00     statique
  224.0.0.22            01-00-5e-00-00-16     statique
  224.0.0.251           01-00-5e-00-00-fb     statique
  224.0.0.252           01-00-5e-00-00-fc     statique
  239.255.255.250       01-00-5e-7f-ff-fa     statique
  255.255.255.255       ff-ff-ff-ff-ff-ff     statique
```


## 4. Utilisation d'un des deux comme gateway

Ca, ça peut toujours dépann irl. Comme pour donner internet à une tour sans WiFi quand y'a un PC portable à côté, par exemple.

L'idée est la suivante :

- vos PCs ont deux cartes avec des adresses IP actuellement
  - la carte WiFi, elle permet notamment d'aller sur internet, grâce au réseau YNOV
  - la carte Ethernet, qui permet actuellement de joindre votre coéquipier, grâce au réseau que vous avez créé :)
- si on fait un tit schéma tout moche, ça donne ça :

```schema
  Internet           Internet
     |                   |
    WiFi                WiFi
     |                   |
    PC 1 ---Ethernet--- PC 2
    
- internet joignable en direct par le PC 1
- internet joignable en direct par le PC 2
```

- vous allez désactiver Internet sur une des deux machines, et vous servir de l'autre machine pour accéder à internet.

```schema
  Internet           Internet
     X                   |
     X                  WiFi
     |                   |
    PC 1 ---Ethernet--- PC 2
    
- internet joignable en direct par le PC 2
- internet joignable par le PC 1, en passant par le PC 2
```

- pour ce faiiiiiire :
  - désactivez l'interface WiFi sur l'un des deux postes
  - s'assurer de la bonne connectivité entre les deux PCs à travers le câble RJ45
  - **sur le PC qui n'a plus internet**
    - sur la carte Ethernet, définir comme passerelle l'adresse IP de l'autre PC
  - **sur le PC qui a toujours internet**
    - sur Windows, il y a une option faite exprès (google it. "share internet connection windows 10" par exemple)
    - sur GNU/Linux, faites le en ligne de commande ou utilisez [Network Manager](https://help.ubuntu.com/community/Internet/ConnectionSharing) (souvent présent sur tous les GNU/Linux communs)
    - sur MacOS : toute façon vous avez pas de ports RJ, si ? :o (google it sinon)

---

🌞**Tester l'accès internet**

- pour tester la connectivité à internet on fait souvent des requêtes simples vers un serveur internet connu
- essayez de ping l'adresse IP `1.1.1.1`, c'est un serveur connu de CloudFlare (demandez-moi si vous comprenez pas trop la démarche)
```
PS C:\Users\b> ping 1.1.1.1

Envoi d’une requête 'Ping'  1.1.1.1 avec 32 octets de données :
Réponse de 1.1.1.1 : octets=32 temps=22 ms TTL=54
Réponse de 1.1.1.1 : octets=32 temps=21 ms TTL=54
Réponse de 1.1.1.1 : octets=32 temps=21 ms TTL=54
Réponse de 1.1.1.1 : octets=32 temps=21 ms TTL=54

Statistiques Ping pour 1.1.1.1:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 21ms, Maximum = 22ms, Moyenne = 21ms
```

🌞 **Prouver que la connexion Internet passe bien par l'autre PC**

- utiliser la commande `traceroute` ou `tracert` (suivant votre OS) pour bien voir que les requêtes passent par la passerelle choisie (l'autre le PC)

> La commande `traceroute` retourne la liste des machines par lesquelles passent le `ping` avant d'atteindre sa destination.
```
PS C:\Users\b> tracert 192.168.137.1

Détermination de l’itinéraire vers Milanese [192.168.137.1]
avec un maximum de 30 sauts :

  1     1 ms     1 ms     1 ms  Milanese [192.168.137.1]

Itinéraire déterminé.
```

## 5. Petit chat privé

![Netcat](./pics/netcat.jpg)

On va créer un chat extrêmement simpliste à l'aide de `netcat` (abrégé `nc`). Il est souvent considéré comme un bon couteau-suisse quand il s'agit de faire des choses avec le réseau.

Sous GNU/Linux et MacOS vous l'avez sûrement déjà, sinon débrouillez-vous pour l'installer :). Les Windowsien, ça se passe [ici](https://eternallybored.org/misc/netcat/netcat-win32-1.11.zip) (from https://eternallybored.org/misc/netcat/).  

Une fois en possession de `netcat`, vous allez pouvoir l'utiliser en ligne de commande. Comme beaucoup de commandes sous GNU/Linux, Mac et Windows, on peut utiliser l'option `-h` (`h` pour `help`) pour avoir une aide sur comment utiliser la commande.  

Sur un Windows, ça donne un truc comme ça :

```schema
C:\Users\It4\Desktop\netcat-win32-1.11>nc.exe -h
[v1.11 NT www.vulnwatch.org/netcat/]
connect to somewhere:   nc [-options] hostname port[s] [ports] ...
listen for inbound:     nc -l -p port [options] [hostname] [port]
options:
        -d              detach from console, background mode

        -e prog         inbound program to exec [dangerous!!]
        -g gateway      source-routing hop point[s], up to 8
        -G num          source-routing pointer: 4, 8, 12, ...
        -h              this cruft
        -i secs         delay interval for lines sent, ports scanned
        -l              listen mode, for inbound connects
        -L              listen harder, re-listen on socket close
        -n              numeric-only IP addresses, no DNS
        -o file         hex dump of traffic
        -p port         local port number
        -r              randomize local and remote ports
        -s addr         local source address
        -t              answer TELNET negotiation
        -u              UDP mode
        -v              verbose [use twice to be more verbose]
        -w secs         timeout for connects and final net reads
        -z              zero-I/O mode [used for scanning]
port numbers can be individual or ranges: m-n [inclusive]
```

L'idée ici est la suivante :

- l'un de vous jouera le rôle d'un *serveur*
- l'autre sera le *client* qui se connecte au *serveur*

Précisément, on va dire à `netcat` d'*écouter sur un port*. Des ports, y'en a un nombre fixe (65536, on verra ça plus tard), et c'est juste le numéro de la porte à laquelle taper si on veut communiquer avec le serveur.

Si le serveur écoute à la porte 20000, alors le client doit demander une connexion en tapant à la porte numéro 20000, simple non ?  

Here we go :

🌞 **sur le PC *serveur*** avec par exemple l'IP 192.168.1.1
```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> .\nc.exe -l -p 9999
coucou
yes
ça marche
lets goooooooooo
allez lol
gggggg

```
🌞 **sur le PC *client*** avec par exemple l'IP 192.168.1.2
```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> .\nc.exe 192.168.137.1 8888

okaay
couc
```
🌞**Visualiser la connexion en cours**

```
PS C:\Windows\system32> netstat -a -n -b
 Impossible d’obtenir les informations de propriétaire
  TCP    192.168.137.2:9999     192.168.137.1:64049    ESTABLISHED
 [nc.exe]
```

```bash
# Windows (dans un Powershell administrateur)
$ netstat -a -n -b

# Linux
$ ss -atnp

# MacOS
$ netstat -a -n # je crois :D
```

🌞 **Pour aller un peu plus loin**
```
PS C:\Windows\system32> netstat -a -n -b | Select-String 9999

  TCP    192.168.137.2:9999     0.0.0.0:0              LISTENING

```
```bash
# Sur Windows/MacOS
$ nc.exe -l -p PORT_NUMBER -s IP_ADDRESS
# Par exemple
$ nc.exe -l -p 9999 -s 192.168.1.37
```

## 6. Firewall

Toujours par 2.

Le but est de configurer votre firewall plutôt que de le désactiver

🌞 **Activez et configurez votre firewall**

```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> .\nc.exe -l -p 9999

SALOUTE
le firewall est activé et ca marche
```
  
# III. Manipulations d'autres outils/protocoles côté client

## 1. DHCP

Bon ok vous savez définir des IPs à la main. Mais pour être dans le réseau YNOV, vous l'avez jamais fait.  

C'est le **serveur DHCP** d'YNOV qui vous a donné une IP.

Une fois que le serveur DHCP vous a donné une IP, vous enregistrer un fichier appelé *bail DHCP* qui contient, entre autres :

- l'IP qu'on vous a donné
- le réseau dans lequel cette IP est valable

🌞**Exploration du DHCP, depuis votre PC**

```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> ipconfig /all 

Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 20-1E-88-3A-B3-35
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::44ee:38cd:6e94:79af%18(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.17.19(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : jeudi 6 octobre 2022 09:04:54
   Bail expirant. . . . . . . . . . . . . : vendredi 7 octobre 2022 09:04:31
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   Serveur DHCP . . . . . . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 253763208
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-5A-6F-F9-B0-25-AA-47-C7-A4
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
                                       1.1.1.1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```


## 2. DNS

Le protocole DNS permet la résolution de noms de domaine vers des adresses IP. Ce protocole permet d'aller sur `google.com` plutôt que de devoir connaître et utiliser l'adresse IP du serveur de Google.  

Un **serveur DNS** est un serveur à qui l'on peut poser des questions (= effectuer des requêtes) sur un nom de domaine comme `google.com`, afin d'obtenir les adresses IP liées au nom de domaine.  

Si votre navigateur fonctionne "normalement" (il vous permet d'aller sur `google.com` par exemple) alors votre ordinateur connaît forcément l'adresse d'un serveur DNS. Et quand vous naviguez sur internet, il effectue toutes les requêtes DNS à votre place, de façon automatique.

🌞** Trouver l'adresse IP du serveur DNS que connaît votre ordinateur**
```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> ipconfig /all
Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Intel(R) Wi-Fi 6 AX201 160MHz
   Adresse physique . . . . . . . . . . . : 20-1E-88-3A-B3-35
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::44ee:38cd:6e94:79af%18(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.17.19(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : jeudi 6 octobre 2022 09:04:54
   Bail expirant. . . . . . . . . . . . . : vendredi 7 octobre 2022 09:04:31
   Passerelle par défaut. . . . . . . . . : 10.33.19.254
   Serveur DHCP . . . . . . . . . . . . . : 10.33.19.254
   IAID DHCPv6 . . . . . . . . . . . : 253763208
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-2A-5A-6F-F9-B0-25-AA-47-C7-A4
   Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       8.8.4.4
                                       1.1.1.1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```

🌞 Utiliser, en ligne de commande l'outil `nslookup` (Windows, MacOS) ou `dig` (GNU/Linux, MacOS) pour faire des requêtes DNS à la main

- faites un *lookup* (*lookup* = "dis moi à quelle IP se trouve tel nom de domaine")
  - pour `google.com`
```
  PS C:\Users\b\netcat-win32-1.11\netcat-1.11> nslookup google.com
Serveur :   dns.google
Address:  8.8.8.8

Réponse ne faisant pas autorité :
Nom :    google.com
Addresses:  2a00:1450:4007:80e::200e
          172.217.18.206
```
  - pour `ynov.com`
```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> nslookup ynov.com
Serveur :   dns.google
Address:  8.8.8.8

Réponse ne faisant pas autorité :
Nom :    ynov.com
Addresses:  2606:4700:20::681a:ae9
          2606:4700:20::ac43:4ae2
          2606:4700:20::681a:be9
          104.26.11.233
          104.26.10.233
          172.67.74.226
```          
  - interpréter les résultats de ces commandes
  - Ca donne le serveur, le dns et les adresses
- déterminer l'adresse IP du serveur à qui vous venez d'effectuer ces requêtes
 172.217.18.206
- faites un *reverse lookup* (= "dis moi si tu connais un nom de domaine pour telle IP")
  - pour l'adresse `231.34.113.12`
```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> nslookup 231.34.113.12
Serveur :   dns.google
Address:  8.8.8.8

*** dns.google ne parvient pas à trouver 231.34.113.12 : Non-existent domain
```
  - pour l'adresse `78.34.2.17`
```
PS C:\Users\b\netcat-win32-1.11\netcat-1.11> nslookup 78.34.2.17
Serveur :   dns.google
Address:  8.8.8.8

Nom :    cable-78-34-2-17.nc.de
Address:  78.34.2.17
```
  - interpréter les résultats
 le premier est attribué à rien ontrairement au deuxième 
  - *si vous vous demandez, j'ai pris des adresses random :)*
  

# IV. Wireshark

**Wireshark est un outil qui permet de visualiser toutes les trames qui sortent et entrent d'une carte réseau.**

On appelle ça un **sniffer**, ou **analyseur de trames.**

![Wireshark](./pics/wireshark.jpg)

Il peut :

- enregistrer le trafic réseau, pour l'analyser plus tard
- afficher le trafic réseau en temps réel

**On peut TOUT voir.**

Un peu austère aux premiers abords, une manipulation très basique permet d'avoir une très bonne compréhension de ce qu'il se passe réellement.

➜ **[Téléchargez l'outil Wireshark](https://www.wireshark.org/).**

🌞 Utilisez le pour observer les trames qui circulent entre vos deux carte Ethernet. Mettez en évidence :

- un `ping` entre vous et votre passerelle
![](https://i.imgur.com/XqOLKps.png)

- un `netcat` entre vous et votre mate, branché en RJ45
![](https://i.imgur.com/GYcyk9b.png)

- une requête DNS. Identifiez dans la capture le serveur DNS à qui vous posez la question.
![](https://i.imgur.com/uGxO3hK.png)

- prenez moi des screens des trames en question
- on va prendre l'habitude d'utiliser Wireshark souvent dans les cours, pour visualiser ce qu'il se passe

# Bilan

**Vu pendant le TP :**

- visualisation de vos interfaces réseau (en GUI et en CLI)
- extraction des informations IP
  - adresse IP et masque
  - calcul autour de IP : adresse de réseau, etc.
- connaissances autour de/aperçu de :
  - un outil de diagnostic simple : `ping`
  - un outil de scan réseau : `nmap`
  - un outil qui permet d'établir des connexions "simples" (on y reviendra) : `netcat`
  - un outil pour faire des requêtes DNS : `nslookup` ou `dig`
  - un outil d'analyse de trafic : `wireshark`
- manipulation simple de vos firewalls

**Conclusion :**

- Pour permettre à un ordinateur d'être connecté en réseau, il lui faut **une liaison physique** (par câble ou par *WiFi*).  
- Pour réceptionner ce lien physique, l'ordinateur a besoin d'**une carte réseau**. La carte réseau porte une adresse MAC  
- **Pour être membre d'un réseau particulier, une carte réseau peut porter une adresse IP.**
Si deux ordinateurs reliés physiquement possèdent une adresse IP dans le même réseau, alors ils peuvent communiquer.  
- **Un ordintateur qui possède plusieurs cartes réseau** peut réceptionner du trafic sur l'une d'entre elles, et le balancer sur l'autre, servant ainsi de "pivot". Cet ordinateur **est appelé routeur**.
- Il existe dans la plupart des réseaux, certains équipements ayant un rôle particulier :
  - un équipement appelé *passerelle*. C'est un routeur, et il nous permet de sortir du réseau actuel, pour en joindre un autre, comme Internet par exemple
  - un équipement qui agit comme **serveur DNS** : il nous permet de connaître les IP derrière des noms de domaine
  - un équipement qui agit comme **serveur DHCP** : il donne automatiquement des IP aux clients qui rejoigne le réseau
  - **chez vous, c'est votre Box qui fait les trois :)**