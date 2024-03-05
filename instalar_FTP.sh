#!/bin/bash 

while true; 
do 

    if systemctl status vsftpd &> /dev/null; then 
        echo "el servicio  esta instalado" 
    else 
        echo "el servicio no esta instalado" 
    fi 

    echo "" 
    echo "1 intalar servicio" 
    echo "2 eliminar servicio" 
    echo "3 iniciar servicio" 
    echo "4 parar servicio  " 
    echo "5 opciones de configuracion" 
    echo "6 Crear un usuario para ftp"
    echo "7 salir servicio  " 
    echo "" 

    read -r -p "elige una opcion " orden 

    case $orden in 

    1) 
        sudo apt install vsftpd 
        sudo mkdir /FTP
        sudo chown nobody:nogroup /FTP
        sudo chmod a-w /FTP
        sudo ufw allow 20/tcp
        sudo ufw allow 21/tcp
        sudo ufw allow 990/tcp
        sudo ufw allow 40000:50000/tcp
    ;; 

    2) 
        sudo apt remove vsftpd 
        sudo apt autoremove vsftpd 
    ;; 

    3) 
        if systemctl start vsftpd &> /dev/null; then 
            echo "el servicio  esta en marcha" 
        fi 
    ;; 

    4) 
        if systemctl stop vsftpd &> /dev/null; then 
            echo "el servicio  esta parado" 
        fi 
    ;; 

    5) 
        echo "Se procedera a realizar la configuración basica."
        
        sudo sed -i 's/anonymous_enable=YES/anonymous_enable=NO/' /etc/vsftpd.conf
        sudo sed -i 's/local_enable=NO/local_enable=YES/' /etc/vsftpd.conf
        
        sudo sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
        sudo sed -i 's/#write_enable=NO/write_enable=YES/' /etc/vsftpd.conf
        
        sudo sed -i 's/#chroot_local_user=YES/chroot_local_user=YES/' /etc/vsftpd.conf
        sudo sed -i 's/#chroot_local_user=NO/chroot_local_user=YES/' /etc/vsftpd.conf
        
        echo "user_sub_token="|sudo tee -a /etc/vsftpd.conf
        sudo sed -i 's/user_sub_token=/user_sub_token=$USER/' /etc/vsftpd.conf
        sudo sed -i 's/user_sub_token=$USER$USER//' /etc/vsftpd.conf
        
        echo "local_root=/FTP"|sudo tee -a /etc/vsftpd.conf
        sudo sed -i 's|local_root=/FTP/|local_root=/FTP/$USER|' /etc/vsftpd.conf
        sudo sed -i 's|local_root=/FTP/$USER$USER| |' /etc/vsftpd.conf
        
        echo "pasv_min_port=40000"|sudo tee -a /etc/vsftpd.conf
        echo "pasv_max_port=50000"|sudo tee -a /etc/vsftpd.conf
        
        echo "userlist_enable=YES"|sudo tee -a /etc/vsftpd.conf
        echo "userlist_file=/etc/vsftpd.userlist"|sudo tee -a /etc/vsftpd.conf
        echo "userlist_deny=NO"|sudo tee -a /etc/vsftpd.conf
        
        
        sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
        sudo sed -i 's|rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem|# rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem|' /etc/vsftpd.conf
        sudo sed -i 's|rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key|# rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key|' /etc/vsftpd.conf
        echo "rsa_cert_file=/etc/ssl/private/vsftpd.pem"|sudo tee -a /etc/vsftpd.conf
        echo "rsa_private_key_file=/etc/ssl/private/vsftpd.pem"|sudo tee -a /etc/vsftpd.conf
        sudo sed -i 's/ssl_enable=NO/ssl_enable=YES/' /etc/vsftpd.conf
        
        echo "allow_anon_ssl=NO"|sudo tee -a /etc/vsftpd.conf
        echo "force_local_data_ssl=YES"|sudo tee -a /etc/vsftpd.conf
        echo "force_local_logins_ssl=YES"|sudo tee -a /etc/vsftpd.conf
        
        echo "ssl_tlsv1=YES"|sudo tee -a /etc/vsftpd.conf
        echo "ssl_sslv2=NO"|sudo tee -a /etc/vsftpd.conf
        echo "ssl_sslv3=NO"|sudo tee -a /etc/vsftpd.conf
        
        echo "require_ssl_reuse=NO"|sudo tee -a /etc/vsftpd.conf
        echo "ssl_ciphers=HIGH"|sudo tee -a /etc/vsftpd.conf

        sudo systemctl restart vsftpd 
        
    ;; 

    6)
            /bin/bash FTP.sh
    ;;
    7) 
        break 
    ;; 

    *)
        echo "Opcion invalida"
    ;;

    esac 
done 
