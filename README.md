# Automap
Automap is a script created to speed up the scanning and enumeration process. 
In this first version, the script does the following tasks: 

- Ping Sweep
- Full Port Scan
- Directory Enumeration on HTTP Ports

## Process
The tool runs the mentioned tasks in the following order:

1. Ping Sweeps the chosen network
2. Starts the scan on each host found, one at a time
    1. Runs a Simple Port Scan on the target (Scans all 65535 ports)
    2. Runs a Full Port Scan (nmap -A) on every open port detected
    3. Does a directory enumeration on all ports detected running http
  
## Tools Used
- Scanning:
  - nmap
- Enumeration:
  - gobuster

