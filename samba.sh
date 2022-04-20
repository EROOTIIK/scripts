#!/bin/bash

if ! grep -q "allow-hotplug enp0s8" /etc/network/interfaces; then
  echo "# Seconde interface
allow-hotplug enp0s8
iface enp0s8 inet dhcp" >> /etc/network/interfaces
fi

ifup enp0s8
apt install samba -y
if ! grep -q "\[partage\]" /etc/samba/smb.conf; then
  echo "[partage]
   # Chemin d’accès du dossier partagé
   path = /
   # Rends visible le partage
   browseable = yes
   # Autorise l’écriture des fichiers/dossiers
   read only = no
   # Autorise seulement le superutilisateur à accéder au partage
   valid users = root" >> /etc/samba/smb.conf
fi
echo -e "root\nroot" | smbpasswd -a root
service smbd restart