#!/bin/bash

printBanner () {
    echo -e "\n"
    echo "   _____          __                                "
    echo "  /  _  \  __ ___/  |_  ____   _____ _____  ______  "
    echo " /  /_\  \|  |  \   __\/  _ \ /     \\__  \ \____ \ "
    echo "/    |    \  |  /|  | (  <_> )  Y Y  \/ __ \|  |_> >"
    echo "\____|__  /____/ |__|  \____/|__|_|  (____  /   __/ "
    echo "        \/                         \/     \/|__|    "
    echo -e "\n"
}

if [ "$1" == "" -o "$2" == "" ]
then
    printBanner
	echo "Usage: $0 <NETWORK/MASK> <WORDLIST>"
	echo "Example: $0 192.168.0.0/24 ./directoriesWordlist.txt"
    echo -e "\n"
else

    range=$1
    network=`echo $range | cut -d "/" -f1`
    mask=`echo $range | cut -d "/" -f2`
    
    wordlistPath=$2

    printBanner

    mkdir $network
    
    echo -e "\n"
    echo "--------- REALIZANDO PING SWEEP NA REDE $range ---------"

    nmap -sn -PE $range | grep report | cut -d ' ' -f5 > $network/hosts

    echo "Hosts identificados:"
    cat $network/hosts

    echo -e "\n"
    echo "--------- REALIZANDO PORT SCAN DOS HOSTS ---------"

    for host in $(cat $network/hosts)
    do
        mkdir $network/$host
        
        echo "Portas abertas no host $host:"

        nmap -T4 -p- -Pn $host 2> /dev/null | grep 'open\|closed\|filtered\|unfiltered' | grep -v ':' | grep -v 'All' | cut -d ' ' -f1 | cut -d '/' -f1 > $network/$host/openPorts
        cat $network/$host/openPorts

        echo "Realizando analise completa das portas"
    	nmap -A -Pn -p $(tr '\n' , < $network/$host/openPorts) $host > $network/$host/scanResult 2> /dev/null
        cat $network/$host/scanResult | grep http | grep 'open\|closed\|filtered\|unfiltered' | cut -d " " -f1 | cut -d "/" -f1 > $network/$host/httpPorts

        for porta in $(cat $network/$host/httpPorts)
        do
            echo "Realizando enumeracao de diretorios (Porta $porta)"
                
            gobuster dir --url http://$host:$porta --wordlist $wordlistPath --threads 100 -a "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36" -q > $network/$host/diretorios-$porta 2> /dev/null
        done

        rm $network/$host/httpPorts

        wait
        
        echo "Scan do host $host finalizado!"
        echo -e "\n"

    done

    echo "Scan concluido com sucesso!"

fi