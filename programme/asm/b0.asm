                                ;#include<stdio.h>

    BUF DUP 0x10                ;int buffer[16] = {0};
                                ;
MAIN LDA    RF  0xF0            ;initialize stack pointer
     LDA    R1  1               ;initialize constant 1
     LDA    RC  0x00            ;int i;
     LDA    RB  0x00            ;int X;
     LDA    RA  0x00            ;int digit;
     LDA    R9  BUF             ;int* R9 = buffer;
     LDA    R8  0x00            ;int halt;
     LDA    R7  0x80            ;int plus = 0x802B;
     LDA    R2  8               ;
     SHL    R7  R7  R2          ;
     LDA    R2  0x2B            ;           
     ADD    R7  R7  R2          ;
     LDA    R6  0x80            ;int multiplier = 0x802A;
     LDA    R2  8               ;
     SHL    R6  R6  R2          ;
     LDA    R2  0x2A            ;
     ADD    R6  R6  R2          ;
     LDA    R5  0x80            ;int newline = 0x800A;
     LDA    R2  8               ;
     SHL    R5  R5  R2          ;
     LDA    R2  0x0A            ;
     ADD    R5  R5  R2          ;
     LDA    R4  0X00            ;int controller;
                                ;int main(){
                                ;
    JL  RE  LL0                 ;A00:my_getchar();
    HLT                         ;return 0;
                                ;}
                                ;
POL LD  R3  0xFE                ;check control register
    BZ  R3  POL                 ;if control register is 0, goto POL
    ST  R0  0xFE                ;reset control register to 0
    JR  RE                      ;RET
                                ;
                                ;void my_getchar()
                                ;{
LL0 SUB RF  RF  R1              ;increase the stack by 1 position
    STI RE  RF                  ;push RE
    JL  RE  POL                 ;call pulling routine
    LD  RC  0xFF                ;R2 = getchar();
    LDI RE  RF                  ;copy the return adress from TOS into RE
    ADD RF  RF  R1              ;shrink the stack by 1 position
    JR  RE                      ;RET
                                ;}