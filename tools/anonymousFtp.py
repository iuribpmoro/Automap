#!/usr/bin/python3
import sys, socket

print("Testando Anonymous FTP!")

if len(sys.argv) <= 1:
    print ("Modo de uso: ./anonymousFtp.py <IP>")
else:
    ip = sys.argv[1]
    porta = 21

    connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    connection.settimeout(10)

    try:
        connection.connect_ex((ip, porta))
        banner = connection.recv(1024).decode()
        #print(banner)

        connection.send(b"USER anonymous\r\n",)
        response = connection.recv(1024).decode()
        #print(response)

        connection.send(b"PASS  \r\n")
        response = connection.recv(1024).decode()
        #print(response)
        print("Login anônimo disponível!")
    except socket.timeout:
        print("Nao foi possivel conectar!")
