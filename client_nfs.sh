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

echo "\033[95;40mInstalar nfs-common y rpcbind?  \033[39m\\033[49m[\033[92;40my\033[39m\\033[49m/\033[31;40mn\033[39m\\033[49m] "
read install
if [ $install = "y" ] || [ $install = "Y" ] || [ $install = "s" ] || [ $install = "S" ]; then
    echo "$prompt sudo apt install nfs-common rpcbind"
    sudo apt install nfs-common rpcbind
fi

echo "\033[95;40mIP del servidor NFS?:\033[39m\\033[49m"
read ServerIp
ping -c 1 $ServerIp -W2
if [ $? = 0 ]; then echo "\033[95;40mLa máquina esta activa.\033[39m\\033[49m"
else echo "\033[31;40mNo se pudo encontrar el servidor ServerIp.\033[39m\\033[49m"; fi

echo "\033[95;40mCuantos puntos de montaje(carpetas) deseas hacer?:\033[39m\\033[49m"
read repeticiones

for i in $(seq 1 1 $repeticiones); do
    echo "\033[95;40mNombre del punto de montaje numero \e[0;33m\033[1m$i\033[95;40m(Este nombre a de ser el mismo que el de la carpeta compartida):\033[39m\\033[49m "
    read nombre
    ruta=$(echo "/mnt/nfs/")
    echo "\033[95;40mEl nombre del punto de montaje $nombre y su ruta $ruta$nombre es correcta? \033[39m\\033[49m[\033[92;40my\033[39m\\033[49m/\033[31;40mn\033[39m\\033[49m] "
    read confirmacion
    if [ $confirmacion = "y" ] || [ $confirmacion = "Y" ] || [ $confirmacion = "s" ] || [ $confirmacion = "S" ]; then
        echo "$prompt mkdir -p $ruta$nombre"
        sudo mkdir -p $ruta$nombre
        echo "$prompt sudo chmod -R 777 $ruta$nombre"
        sudo chmod -R 777 $ruta$nombre
        echo "$prompt sudo mount $ServerIp:$nombre $ruta$nombre"
        sudo mount $ServerIp:$nombre $ruta$nombre
        echo "$prompt echo \"$ServerIp:$nombre $ruta$nombre nfs auto,noatime,nolock,bg,nfsvers=3,intr,tcp,actimeo=1800 0 0\" >> /etc/fstab"
        sudo sh -c "echo \"$ServerIp:$nombre $ruta$nombre nfs auto,noatime,nolock,bg,nfsvers=3,intr,tcp,actimeo=1800 0 0\" >> /etc/fstab"
        sudo systemctl daemon-reload
    fi
done
echo "\033[95;40mLas unidades fueron montadas inicialmente de forma temporal y actualmente se a cambiado a permanente(reiniciar al finalizar para aplicar)?:\033[39m\\033[49m"
echo "\033[95;40mEspacio de las unidades montadas?:\033[39m\\033[49m"
echo "$prompt sudo df -h"
sudo df -h

