#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
hostname=$(cat /etc/hostname)
prompt=$(echo "\033[92;40m$(whoami)@\033[31;40m$(cat /etc/hostname)\033[39m\\033[49m:~$ ")

echo "\033[95;40mActualizar todo? \033[39m\\033[49m[\033[92;40my\033[39m\\033[49m/\033[31;40mn\033[39m\\033[49m] "
read update 
if  [ $update = "y" ] || [ $update = "Y" ] || [ $update = "s" ] || [ $update = "S" ]; then
    echo "$prompt sudo apt update -y && sudo apt upgrade -y"
    sudo apt update -y && sudo apt upgrade -y
fi

echo "\033[95;40mInstalar nfs-kernel-server?  \033[39m\\033[49m[\033[92;40my\033[39m\\033[49m/\033[31;40mn\033[39m\\033[49m] "
read install
if [ $install = "y" ] || [ $install = "Y" ] || [ $install = "s" ] || [ $install = "S" ]; then
    echo "$prompt sudo apt install nfs-kernel-server"
    sudo apt install nfs-kernel-server
fi

echo "\033[95;40mServicio NFS instalado:\033[39m\\033[49m"
echo "$prompt sudo systemctl status nfs-server"
sudo systemctl status nfs-server

echo "\033[95;40mcomprobando nfsd en filesystems:\033[39m\\033[49m"
echo "$prompt grep nfsd /proc/filesystems"
grep nfsd /proc/filesystems


echo "\033[95;40mcuantas carpetas deseas compartir?:\033[39m\\033[49m"
read repeticiones

for i in $(seq 1 1 $repeticiones); do
    echo "\033[95;40mRuta de la carpeta \e[0;33m\033[1m$i\033[95;40m:\033[39m\\033[49m "
    read ruta
    echo "\033[95;40mLa ruta $ruta es correcta?  \033[39m\\033[49m[\033[92;40my\033[39m\\033[49m/\033[31;40mn\033[39m\\033[49m] "
    read confirmacion
    if [ $confirmacion = "y" ] || [ $confirmacion = "Y" ] || [ $confirmacion = "s" ] || [ $confirmacion = "S" ]; then
        echo "$prompt mkdir $ruta"
        sudo mkdir -p $ruta
        echo "$prompt sudo chown nobody:nogroup $ruta"
        sudo chown nobody:nogroup $ruta
        echo "$prompt sudo chmod -R 777 $ruta"
        sudo chmod -R 777 $ruta
        echo "$prompt echo \"$ruta *(rw,sync,no_root_squash,no_subtree_check)\" >> /etc/exports"
        sudo sh -c "echo \"$ruta *(rw,sync,no_root_squash,no_subtree_check)\" >> /etc/exports"
    fi
done

echo "\033[95;40mReiniciar el servicio nfs-kernel-server para aplicar los cambios?  \033[39m\\033[49m[\033[92;40my\033[39m\\033[49m/\033[31;40mn\033[39m\\033[49m] "
read install
if [ $install = "y" ] || [ $install = "Y" ] || [ $install = "s" ] || [ $install = "S" ]; then
    echo "$prompt sudo systemctl restart nfs-kernel-server && sudo systemctl status nfs-kernel-server"
    sudo systemctl restart nfs-kernel-server
    sudo systemctl status nfs-kernel-server
    
fi

echo "C:"
