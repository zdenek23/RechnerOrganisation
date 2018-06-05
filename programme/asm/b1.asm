                                ;#include<stdio.h>

    BUF DUP 0x10                ;int buffer[16] = {0};
                                ;
MAIN LDA    RF  0xF0            ;initialize stack pointer
     LDA    R1  1               ;initialize constant 1
     LDA    RC  0               ;int i;
     LDA    RB  0               ;int X;
     LDA    RA  0               ;int digit;
     LDA    R9  BUF             ;int* R9 = buffer;
     LDA    R8  0               ;int halt;
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
     LDA    R4  0               ;int controller;
                                ;int main(){
                                ;
A0  JL  RE  LL0                 ;A0:my_getchar();
    JL  RE  CC                  ;check_char();
    BZ  R8  A0                  ;if (R8==0) goto A0;
    HLT                         ;return 0;
                                ;}
                                ;
POL LD  R2  0xFE                ;check control register
    BZ  R2  POL                 ;if control register is 0, goto POL
    ST  R0  0xFE                ;reset control register to 0
    JR  RE                      ;RET
                                ;
                                ;void my_getchar()
                                ;{
LL0 SUB RF  RF  R1              ;prolog: increase the stack by 1 position
    STI RE  RF                  ;push RE, end prolog
    JL  RE  POL                 ;call pulling routine
    LD  RC  0xFF                ;R2 = getchar();
    LDI RE  RF                  ;epilog: copy the return adress from TOS into RE
    ADD RF  RF  R1              ;shrink the stack by 1 position
    JR  RE                      ;RET
                                ;}
                                ;void check_char()
                                ;{
CC  SUB RF  RF  R1              ;prolog
    STI RE  RF                  ;
    LDA R2  3                   ;3 local variables
    SUB RF  RF  R2              ;set new stack pointer
    STI R0  0   RF              ;int result_ctrl = 0;
    STI R0  1   RF              ;int number_ctrl = 0;
    STI R2  2   RF              ;int nl_ctrl = 0;
    LDA R2  4                   ;R2 = 4   ;
    SUB R3  R4  R2              ;R3 = R4 - R2;
    BP  R3  G0                  ;if (R3>0) goto G0;
    BZ  R0  G1                  ;goto G1;
G0  STI R1  0   RF              ;G0:result_ctrl = 1;
    SUB R4  R4  R2              ;R4 -= 4   ;
    BZ  R0  G2                  ;goto G2;
G1  BZ  R3  G3                  ;G1:if (R3==0) goto G3;
    BZ  R0  G2                  ;goto G2;
G3  STI R1  0   RF              ;G3:result_ctrl = 1;
    SUB R4  R4  R2              ;R4 -= 4   ;
G2  LDA R2  2                   ;R2 = 2   ;
    SUB R3  R4  R2              ;R3 = R4 - R2;
    BP  R3  H0                  ;if (R3>0) goto H0;
    BZ  R0  H1                  ;goto H1;
H0  STI R1  1   RF              ;H0:number_ctrl = 1;
    SUB R4  R4  R2              ;R4 -= R2;
    BZ  R0  H2                  ;goto H2;
H1  BZ  R3  H3                  ;H01:if (R3==0) goto H3;
    BZ  R0  H2                  ;goto H2;
H3  STI R1  2   RF              ;H03:number_ctrl = 1;
    SUB R4  R4  R2              ;R4 -= R2;
H2  STI R4  2   RF              ;H02:nl_ctrl = R4;
    LDA R4  0                   ;R4 = 0;
    LDA R2  3                   ;R2 = EOF;
    SUB R2  R2  RC              ;R2 -= RC;
    BZ  R2  F1                  ;if (R2==0) goto F1;
    ;
    BZ  R0  F0
    ;                  ;goto F2;
F1  LDA R8  1                   ;F1:halt = 1;
;F2  
F0  LDI R2  0   RF              
    BP  R2  I0                  ;F0:if (result_ctrl>0) goto I0;
    BZ  R0  I1                  ;goto I1;
I0  LDA R2  4                   ;I0:R2 = 4   ;
    ADD R4  R4  R2              ;R4 += R2;
I1  LDI R2  1   RF              ;
    BP  R2  J0                  ;I1:if (number_ctrl>0) goto J0;
    BZ  R0  J1                  ;goto J1;
J0  LDA R2  2                   ;J0:R2 = 2   ;
    ADD R4  R4  R2              ;R4 += R2;
J1  LDI R2  2   RF              ;
    BP  R2  K0                  ;J1:if (nl_ctrl>0) RD++;
    BZ  R0  K1                  ;goto K1;
K0  ADD R4  R4  R1              ;
K1  ADD RF  RE  R0              ;epilog: restore old stack pointer
    LDI RE  RF                  ;POP RE
    ADD RF  RF  R1              ;
    JR  RE                      ;
                                ;}