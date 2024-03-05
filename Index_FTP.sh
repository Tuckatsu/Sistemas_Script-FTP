#!/bin/bash 
while true 
do 
    echo"" 
    echo"" 
    ip a | cut -d: -f9 
    echo "" 
    if systemctl status vsftpd &> /dev/null; then 
        echo "el servicio  esta instalado" 
    else 
        echo "el servicio no esta instalado" 
    fi 
    
    if docker ps | grep "ftp"  &> /dev/null; then 
        echo "el servicio  esta instalado" 
    else 
        echo "el servicio no esta instalado"
    fi 

    echo "" 
    echo "1 configurar servicio con comandos" 
    echo "2 configurar servicio con ansible" 
    echo "3 configurar servicio con Docker" 
    echo "4 salir servicio  " 
    echo "" 

    read -r -p "elige una opcion " orden 
    echo "" 
    case $orden in 
    1) 
        bash instalar_FTP.sh 
    ;; 
    
    2) 
        bash instalar_ansible.sh 
    ;; 
    
    3)  
        bash instalar_docker.sh 
    ;; 

    4)  
        break 
    ;; 

    *) 
        echo "elige una de las opciones disponibles" 
    ;; 
    
    esac 
done 