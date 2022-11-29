# TP1 : Are you dead yet ?


---

- [TP1 : Are you dead yet ?](#tp1--are-you-dead-yet-)
  - [II. Feu](#ii-feu)

---

## II. Feu

Première méthode :):
```
-bash-5.1$ cd boot/  (par erreur j'ai un peu casser mon bash :) )
-bash-5.1$ sudo rm loader
```
j'ai supprimer le chargement, le chargement au reboot ne se fait pas et reste bloqué.
La machine est cassé. ;)

Deuxième méthode :):

Pour cette manip, j'ai touché au disque dur, j'ai donc détruit le disques dur avec :  ```sudo nano sda ``` et ajouter "shitconf"; lorsque je reboot plus rien ne se passe, j'ai un écran noir.
La machine est cassé. ;)

Troisième méthode :): 
```
sudo chmod 666 ../../etc/shadow
```
je donne les permessions au fichier shadow.
```
sudo nano ../../etc/shadow
```
je modifie la ligne root et orealyz pour changer le mot de passe de root et orealyz.
Je ne peux plus me connecté car le mot de passe est changé.
```
root:$6$xM/AN.5qX57UGhOE$Qaqg4lY4edGqRWvV0qgrtgrgVTGenzMNlECzTUkxySs7NCUD3YEMAXswRitt4EZyhfi6hL4QgHxgBoZQG1PYQSpLr7g.::0:9999>
bin:*:19123:0:99999:7:::
daemon:*:19123:0:99999:7:::
adm:*:19123:0:99999:7:::
lp:*:19123:0:99999:7:::
sync:*:19123:0:99999:7:::
shutdown:*:19123:0:99999:7:::
halt:*:19123:0:99999:7:::
mail:*:19123:0:99999:7:::
operator:*:19123:0:99999:7:::
games:*:19123:0:99999:7:::
ftp:*:19123:0:99999:7:::
nobody:*:19123:0:99999:7:::
systemd-coredump:!!:19279::::::
dbus:!!:19279::::::
tss:!!:19279::::::
sssd:!!:19279::::::
sshd:!!:19279::::::
chrony:!!:19279::::::
systemd-oom:!*:19279::::::
orealyz:$6$mbdtR45cWQMH3ii2grtgrtg$fyaf2BVw9Li6yqoH4bIKh613VsjeecekiiceickekeecijcejfjejfijeffifnefeSLp/grtCJmxWSGoFaUA3r5/cU7>
tcpdump:!!:19279::::::
```
La machine est cassé. ;)

Quatrième méthode :) :
Je vais dans le fichier de gestionnaire de tache répétez.
```
sudo crontab -e
```
j'ajoute une ligne qui permet de relancer la vm toutes les minutes ce qui fait que c'est embêtant d'utiliser la machine.
```* * * * * /sbin/shutdown -h now```
La machine est cassé. ;)
