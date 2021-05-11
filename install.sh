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

emojiCheck='\xE2\x9C\x85'
emojiCross='\xE2\x9D\x8C'

# ------------------------------- Set variables ------------------------------ #

nmapInstalled=0
goInstalled=0
gobusterInstalled=0

# -------------------------------- Check Tools ------------------------------- #

genericError () {
    echo -e "${red}${bold}\nError while running the script! Exiting...${reset}\n"
    exit
}

genericSuccess () {
    echo -e "${green}${bold}\nThe installation was successfull, enjoy Automap!${reset}\n"
    exit
}

checkNmap () {
    if command -v nmap &> /dev/null
    then
        nmapInstalled=1
        
        echo -e "nmap\t\t${emojiCheck}"
    else
        echo -e "nmap\t\t${emojiCross}"
    fi
}

checkGo () {
    if command -v go &> /dev/null
    then
        goInstalled=1
        
        echo -e "go\t\t${emojiCheck}"
    else
        echo -e "go\t\t${emojiCross}"
    fi
}

checkGobuster () {
    if command -v gobuster &> /dev/null
    then
        gobusterInstalled=1
        
        echo -e "gobuster\t${emojiCheck}"
    else
        echo -e "gobuster\t${emojiCross}"
    fi
}

checkTools () {
    echo -e "${bold}Checking Tools...${reset}"
    
    checkNmap
    checkGo
    checkGobuster

}

installNmap () {
    echo "${bold}Installing nmap...${reset}"
    sudo apt install nmap -y > /dev/null 2>/dev/null

    commandResult=$?

    if [ commandResult ]; then
        echo -e "${green}${bold}Nmap installed successfully!\n${reset}"
    else
        echo -e "${red}${bold}Nmap could not be installed!\n${reset}"
        exit
    fi
    
}

installGo () {
    echo -e "${red}${bold}Please install Go and try again!\n${reset}"
    exit
}

installGobuster () {
    echo "${bold}Installing gobuster...${reset}"
    go install github.com/OJ/gobuster/v3@latest

    commandResult=$?

    if [ commandResult ]; then
        echo -e "${green}${bold}Gobuster installed successfully!\n${reset}"
    else
        echo -e "${red}${bold}Gobuster could not be installed!\n${reset}"
        exit
    fi
}

installTools () {

    echo -e "${bold}\nUpdating...${reset}"
    sudo apt update > /dev/null 2>/dev/null

    if [ $nmapInstalled -ne 1 ]; then
        installNmap
    fi

    if [ $goInstalled -ne 1 ]; then
        installGo
    fi

    if [ $gobusterInstalled -ne 1 ]; then
        installGobuster
    fi

}

# ---------------------------------------------------------------------------- #
#                                     Main                                     #
# ---------------------------------------------------------------------------- #

echo -e "${bold}${randomColor}\nAutomap - Requirements Installation:${reset}\n"

checkTools

if [ $nmapInstalled -eq 1 -a $goInstalled -eq 1 -a $gobusterInstalled -eq 1 ]; then
    genericSuccess
fi

echo -e "\n${bold}Would you like to install all necessary tools? (yes/no)${reset}"
read response

if [ -z $response ]; then
    echo -e "${red}${bold}\nIncorrect input, please insert 'yes' or 'no'.${reset}\n"
    exit
elif [ $response == "yes" ]; then
    installTools
    commandResult=$?
    if [ commandResult ]; then
        genericSuccess
    else
        echo -e "${red}${bold}There was an error while installing the tools. Exiting...\n${reset}"
        exit
    fi
    
elif [ $response == "no" ]; then
    genericSuccess
else
    echo -e "${red}${bold}\nIncorrect input, please insert 'yes' or 'no'.${reset}\n"
    exit
fi
