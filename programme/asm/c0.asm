                            ;include <stdio.h>

;=============================================================
                            ;int main(){
                            ;
MAIN LDA RF 0xF0            ;initialize stack pointer
     ADD RE RF R0           ;initializa MAIN base pointer
     LDA R1 1               ;constant 1
     LDA R4 BUF             ;int* buffer;
     ST  R5 H               ;int halt;

                            ;
A0  JL  RD  LL0             ;A0:getchar();
                            ;check_char();
    BZ  R5  A0              ;if (halt==0) goto A00;
    
    ADD RF  RE  R0          ;epilog: restore old stack pointer
    LDI RE  RF              ;restore old base pointer
    HLT                     ;return 0;
                            ;}
                            ;
;=============================================================
                            ;getchar(){
LL0 SUB RF  RF  R1          ;
    STI RD  RF              ;PUSH RD
    SUB RF  RF  R1          ;prolog
    STI RE  RF              ;PUSH RE
    ADD RE  RF  R0          ;initialize getchar() base pointer
                            ;    
    LD  RC  0xFF            ;read from stdin
    LDA R2  3               ;R2 = EOF;
    SUB R2  R2  RC          ;temp = EOF - RC
    BZ  R2  F1              ;if (RC==EOF) goto F1
    BZ  R0  F2              ;goto F2
F1  ADD R5   R1  R0          ;halt = 1;
                            ;
F2  ADD RF  RE  R0          ;epilog
    LDI RE  RF              ;
    ADD RF  RF  R1          ;POP RE
    LDI RD  RF              ;POP return adress from stack
    ADD RF  RF R1           ;
    JR  RD                  ;
                            ;
H       DW  0               ;int halt;
BUF     DUP 0x10            ;buffer