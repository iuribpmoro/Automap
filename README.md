# Automap
Automap is a script created to speed up the scanning and enumeration process. 
In this first version, the script does the following tasks: 

- **Ping Sweep**;
- **Full Port Scan**;
- **Directory Enumeration** on HTTP Ports.

## Process
The tool runs the mentioned tasks in the following order:

### Network Mode

1. Ping Sweeps the chosen network;
2. Starts the scan on each host found, one at a time:
   1. Runs a **Simple Port Scan** on the target (Scans all 65535 ports);
   2. Runs a **Full Port Scan** (nmap -A) on every open port detected;
   3. Does a **Directory Enumeration** on all ports detected running http.
  
### Host Mode

1. Runs a **Simple Port Scan** on the target (Scans all 65535 ports);
2. Runs a **Full Port Scan** (nmap -A) on every open port detected;
3. Does a **Directory Enumeration** on all ports detected running http.

## Tools Used
- Scanning:
  - nmap
- Enumeration:
  - gobuster

## Wordlist
The "directories.txt" wordlist available is a combination of dirbuster's medium wordlist and dirb's common wordlist.

# Usage
1. ``chmod +x Automap.sh``
2. ``./Automap.sh <MODE> <NETWORK/MASK> <WORDLIST>``

Example:
``./Automap.sh network 192.168.0.0/24 ./directories.txt``
