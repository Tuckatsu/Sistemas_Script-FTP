#!/bin/bash

read -r -p "Introduce el nombre del usuario que tendra la carpeta FTP: " usuario
    comp=$(getent passwd|cut -d":" -f1|grep -c -E "$usuario")
    if [[ $comp -eq 1 ]]; then
        echo "El usuario ya existe."
        echo "Creando su carpeta de FTP."
        echo "Añadiendo el usuario a la whitelist."
        sudo echo "$usuario" | sudo tee -a /etc/vsftpd.userlist
        if [[ -d /FTP/$usuario  ]]; then
            echo "Ya existe la carpeta."
        else
            sudo mkdir /FTP/"$usuario"
            sudo chmod 700 /FTP/"$usuario"
            sudo chown "$usuario":"$usuario" /FTP/"$usuario"
        fi

    else
        echo "El usuario no existe"
        read -r -p "Quieres crearlo: (S/N) " eleccion
            if [[ $eleccion == "S" || $eleccion == "s" ]]; then
                sudo adduser "$usuario"            
            elif [[ $eleccion == "N" || $eleccion == "n" ]]; then
                echo "El usuario no se creará."
            else
                echo "Respuesta invalida"
            fi
    fi
    


