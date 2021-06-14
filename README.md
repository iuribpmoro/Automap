# Automap
Automap is a script created to speed up the scanning and enumeration process. 
In this first version, the script does the following tasks: 

- **Ping Sweep**;
- **Full Port Scan**;
- **Directory Enumeration** on HTTP Ports.

## Content Table
* [About](#automap)
* [Content Table](#content-table)
* [Prerequisites and Tools](#prerequisites-and-tools)
* [Installation](#installation)
* [Usage](#usage)
* [The Process](#the-process)
* [Wordlists](#wordlists)
* [Project Status](#project-status)
* [Author](#author)


## Prerequisites and Tools
- Languages:
  - Shell Script
  - [GoLang](https://golang.org/)
- Scanning:
  - [Nmap](https://nmap.org/)
- Enumeration:
  - [Gobuster](https://github.com/OJ/gobuster)
  - [Seclists](https://github.com/danielmiessler/SecLists)



## Installation
To install the necessary tools, we developed the install.sh script, also available on this repo. By running it on your terminal, it will first verify which tools are missing and then download and install them on your linux machine.

```bash
# Utilização do install.sh
$ ./install.sh
```

The installation script installs the following tools:



### Tools installed by the script:
- Nmap
- Go
- Gobuster



# Usage

```bash
   _____          __                                
  /  _  \  __ ___/  |_  ____   _____ _____  ______  
 /  /_\  \|  |  \   __\/  _ \ /     \__  \ \____ \ 
/    |    \  |  /|  | (  <_> )  Y Y  \/ __ \|  |_> >
\____|__  /____/ |__|  \____/|__|_|  (____  /   __/ 
        \/                         \/     \/|__|    


Usage: ./Automap.sh <MODE> <NETWORK/MASK> <WORDLIST> [options]
Example: ./Automap.sh network 192.168.0.0/24 ./directoriesWordlist.txt -n 1000


Available Modes: 
	host: scans a specific host
	network: scans all hosts found in a network

Available Options: 
	-n: specifies number of ports to scan
```

- Examples:
  - ``./Automap.sh network 192.168.0.0/24 ./directories.txt``
  - ``./Automap.sh host 192.168.10.200 ./directories.txt -n 1000 ``



## The Process
The tool runs the mentioned tasks in the following order:

### Network Mode

1. Ping Sweeps the chosen network;
2. Starts the scan on each host found, one at a time:
   1. Runs a **Simple Port Scan** on the target (Scans all 65535 ports);
   2. Runs a **Full Port Scan** (nmap -A) on every open port detected;
   3. Does a **Directory Enumeration** on all ports detected running http.
  
### Host Mode

1. Runs a **Simple Port Scan** on the target (Scans all 65535 ports);
2. Runs a **Full Port Scan** (nmap -A -sV) on every open port detected;
3. Does a **Directory Enumeration** on all ports detected running http.



## Wordlists
The "directories.txt" wordlist available is a combination of dirbuster's medium wordlist and dirb's common wordlist.



## Project Status
:construction: In progress :construction:



## Author
### Iuri Moro
[![Gmail Badge](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white
)](mailto:iuribpmoro@gmail.com)[![Linkedin Badge](https://img.shields.io/badge/linkedin%20-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/iuribpmoro/)