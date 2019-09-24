#!/usr/bin/python
# Filename: sub-ror-decryptor.py
# Author:   boku

encrypted = "\xf2\x4a\x79\xa9\x3d\xea\xcb\xa3\x9b\x3b\x8d\x63\xa7"
encrypted += "\xeb\x9e\x7f\x9f\xa8\x79\xdd\x9e\x28\xa6\x64\xd9"
key = "HelloFriend"
decrypted = ""

keyArray = bytearray(key)
keyLength = len(bytearray(key))
count = 0
for x in bytearray(encrypted) : 
	if count == keyLength :
		count = 0
	oddEven = x % 2
	if oddEven == 1:
		x = x >> 1
		x = x + 128
	else:
		x = x >> 1
	x = x - keyArray[count]
	if x < 0 :
		x += 256
	decrypted += '\\x'
	decrypted += '%02x' %x	# Add the rotated left hex to string 
	count += 1

print decrypted
