#!/bin/bash

if [ "$1" == "" ]
then
    echo "AUTOMAP"
	echo "Modo de uso: $0 <REDE>"
	echo "Exemplo: $0 192.168.0.0/24"
else

    range=$1
    network=`echo $range | cut -d "/" -f1`
    mask=`echo $range | cut -d "/" -f2`

    echo -e "\n\n"
    echo "   _____          __                                "
    echo "  /  _  \  __ ___/  |_  ____   _____ _____  ______  "
    echo " /  /_\  \|  |  \   __\/  _ \ /     \\__  \ \____ \ "
    echo "/    |    \  |  /|  | (  <_> )  Y Y  \/ __ \|  |_> >"
    echo "\____|__  /____/ |__|  \____/|__|_|  (____  /   __/ "
    echo "        \/                         \/     \/|__|    "

    mkdir $network
    cd $network
    echo -e "\n\n"
    echo "--------- REALIZANDO PING SWEEP NA REDE $range ---------"

    nmap -sn -PE $range | grep report | cut -d ' ' -f5 > hosts

    echo "Hosts identificados:"
    cat hosts

    echo -e "\n\n"
    echo "--------- REALIZANDO PORT SCAN DOS HOSTS ---------"

    for host in $(cat hosts)
    do
        mkdir $host
        cd $host
        
        echo "Portas abertas no host $host:"

        nmap -T4 -p- -Pn $host 2> /dev/null | grep 'open\|closed\|filtered\|unfiltered' | grep -v ':' | grep -v 'All' | cut -d ' ' -f1 | cut -d '/' -f1 > openPorts
        cat openPorts

        echo "Realizando analise completa das portas"
    	nmap -A -Pn -p $(tr '\n' , < openPorts) $host > scanResult 2> /dev/null
        cat scanResult | grep http | grep 'open\|closed\|filtered\|unfiltered' | cut -d " " -f1 | cut -d "/" -f1 > httpPorts

        for porta in $(cat httpPorts)
        do
            echo "Realizando enumeracao de diretorios (Porta $porta)"
                
            gobuster dir --url http://$host:$porta --wordlist /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt --threads 100 -a "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36" -q > diretorios-$porta 2> /dev/null
        done

        rm httpPorts

        wait
        
        echo "Scan do host $host finalizado!"

        cd ..
    done

    echo "Scan concluido com sucesso!"

    #nmap -T4 -p- -Pn -iL hosts | grep 'open\|closed\|filtered\|unfiltered' | grep -v ':' | cut -d ' ' -f1 | cut -d '/' -f1 > ports

    #nmap -A -Pn -p $(tr '\n' , < ports) > result

fi