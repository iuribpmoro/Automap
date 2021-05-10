#!/bin/bash

# ----------------------------- Color definition ----------------------------- #

black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
bold=`tput bold`
reset=`tput sgr0`

randomColorNumber=$((0 + $RANDOM % 7))
randomColor=`tput setaf ${randomColorNumber}`

# ------------------------------- Print banner ------------------------------- #

printBanner () {
    echo -e "\n${randomColor}${bold}"
    echo "   _____          __                                "
    echo "  /  _  \  __ ___/  |_  ____   _____ _____  ______  "
    echo " /  /_\  \|  |  \   __\/  _ \ /     \\__  \ \____ \ "
    echo "/    |    \  |  /|  | (  <_> )  Y Y  \/ __ \|  |_> >"
    echo "\____|__  /____/ |__|  \____/|__|_|  (____  /   __/ "
    echo "        \/                         \/     \/|__|    "
    echo -e "\n${reset}"
}

checkTools () {
    if ! command -v nmap &> /dev/null
    then
        echo -e "${bold}Nmap was not found in the system!\nExiting...${reset}\n"
        exit
    elif ! command -v gobuster &> /dev/null
    then
        echo -e "${bold}Gobuster was not found in the system!\nExiting...${reset}\n"
        exit
    fi

}

# -------------------------------- Ping Sweep -------------------------------- #

pingSweep () {

    target=$1
    network=$2

    echo -e "\n"
    echo "${blue}${bold}--------- RUNNING PING SWEEP ON THE $target NETWORK ---------${reset}"

    sudo nmap -sn -PE $target | grep report | cut -d ' ' -f5 > hosts

    echo "${bold}Hosts identificados:${reset}"
    cat hosts

}

# --------------------------- Directory Enumeration -------------------------- #

directoryEnumeration () {
    
    host=$1
    wordlistPath=$2

    for porta in $(cat $host/httpPorts)
    do
        echo -e "${bold}Enumerating directories (Port $porta)${reset}"
            
        gobuster dir --url http://$host:$porta --wordlist $wordlistPath --threads 100 -a "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36" -q > $host/diretorios-$porta 2> /dev/null
    done

    wait

}

networkScan () {

    target=$1
    wordlistPath=$2

    network=`echo $target | cut -d "/" -f1`
    mask=`echo $target | cut -d "/" -f2`

    mkdir $network
    cd $network
    
    pingSweep $target $network

    for host in $(cat hosts)
    do
        hostScan $host $wordlistPath
    done

    echo "Scan completed successfully!"
}

hostScan () {
    
    target=$1
    wordlistPath=$2

    mkdir $target
    
    echo -e "\n${blue}${bold}--------- SCANNING TARGET $target ---------${reset}"
        
    echo -e "${bold}Open ports on host $target:${reset}"

    nmap -T4 -p- -Pn $target 2> /dev/null | grep 'open\|closed\|filtered\|unfiltered' | grep -v ':' | grep -v 'All' | cut -d ' ' -f1 | cut -d '/' -f1 > $target/openPorts
    cat $target/openPorts

    echo -e "\n${bold}Running full analysis of the ports...${reset}"
    nmap -A -Pn -p $(tr '\n' , < $target/openPorts) $target > $target/scanResult 2> /dev/null
    cat $target/scanResult | grep http | grep 'open\|closed\|filtered\|unfiltered' | cut -d " " -f1 | cut -d "/" -f1 > $target/httpPorts
    echo -e "${green}Scan results saved on $target/scanResult ${reset}\n"

    directoryEnumeration $target $wordlistPath
    
    echo -e "\n${green}${bold}Scan on host $target completed!${reset}"

}

if [ "$1" == "" -o "$2" == "" -o "$3" == "" ]
then
    printBanner
	echo -e "${bold}Usage: ${reset}./Automap.sh <MODE> <NETWORK/MASK> <WORDLIST>"
	echo -e "${bold}Example: ${reset}./Automap.sh network 192.168.0.0/24 ./directoriesWordlist.txt"
    echo -e "\n"

    echo -e "${bold}Available Modes: ${reset}"
    echo -e "\thost: scans a specific host"
    echo -e "\tnetwork: scans all hosts found in a network"

    echo -e "\n"
else
    
    printBanner

    checkTools
    
    target=$2
    wordlistPath=$3

    if [ "$1" == "host" ]
    then
        
        hostScan $target $wordlistPath

    elif [ "$1" == "network" ]
    then

        networkScan $target $wordlistPath

    fi

fi
