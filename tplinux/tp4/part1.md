# Partie 1 : Partitionnement du serveur de stockage


![Part please](../pics/part_please.jpg)

🌞 **Partitionner le disque à l'aide de LVM**

```
[orealyz@storage /]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
```
  
```
[orealyz@storage /]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
```

```
[orealyz@storage /]$ sudo lvcreate -l 100%FREE storage -n first_data
  Logical volume "first_data" created.
```

🌞 **Formater la partition**

```
[orealyz@storage /]$ mkfs -t ext4 dev/storage/first_data
mke2fs 1.46.5 (30-Dec-2021)
mkfs.ext4: Permission denied while trying to determine filesystem size
[orealyz@storage /]$ sudo !!
sudo mkfs -t ext4 dev/storage/first_data
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 523264 4k blocks and 130816 inodes
Filesystem UUID: 4fbf1c10-a317-46a7-ac22-771a36582764
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
``` 

🌞 **Monter la partition**


```
[orealyz@storage /]$ mkdir /mnt/first_data1
mkdir: cannot create directory ‘/mnt/first_data1’: Permission denied
[orealyz@storage /]$ sudo !!
sudo mkdir /mnt/first_data1
```

  ```
[orealyz@storage /]$ sudo mount dev/storage/first_data mnt/first_data1/
  ```

    ```
[orealyz@storage /]$ df -h | grep first
/dev/mapper/storage-first_data  2.0G   24K  1.9G   1% /mnt/first_data1
    ```
  - prouvez que vous pouvez lire et écrire des données sur cette partition
  ```
[orealyz@storage first_data1]$ sudo mkdir test1
[orealyz@storage first_data1]$ ls
lost+found  test1
  ```

```
[orealyz@storage first_data1]$ sudo !!
sudo vim /etc/fstab
[orealyz@storage first_data1]$ sudo cat /etc/fstab

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
/dev/storage/first_data /mnt/first_data1 ext4 defaults 0 0
```
```
[orealyz@storage mnt]$  sudo umount /mnt/first_data1
[orealyz@storage mnt]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/first_data1 does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/mnt/first_data1         : successfully mounted
```

Pour la partie 2, c'est ici-> [part2](part2.md)😊