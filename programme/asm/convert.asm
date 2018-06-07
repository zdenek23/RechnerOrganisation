                            ;include <stdio.h>

;=============================================================
                            ;int main(){
                            ;
MAIN LDA RF 0xF0            ;initialize stack pointer
     ADD RE RF  R0          ;initialize MAIN base pointer
     LDA R1 1               ;constant 1
     LDA R4 BUF             ;int* buffer;
                            ;
    JL  RD  CV              ;
                            ;check_char();
    ;BZ  R5  A0              ;if (halt==0) goto A00;
    
    ADD RF  RE  R0          ;epilog: restore old stack pointer
    LDI RE  RF              ;restore old base pointer
    HLT                     ;return 0;
                            ;}
                            ;
;=============================================================
                            ;void convert(){
CV  SUB RF  RF  R1          ;
    STI RD  RF              ;PUSH RD
    SUB RF  RF  R1          ;prolog
    STI RE  RF              ;PUSH RE
    ADD RE  RF  R0          ;initialize convert() base pointer
                            ;
    LD  RB  X               ;                        
    BZ  R6  E0              ;if (digit==0) goto E0;
    LDA R2  0xA             ;temp = 10;
    ADD R3  RB  R0          ;temp2 = X;
    SUB R2  R2  R1          ;temp -= 1;
C0  ADD RB  RB  R3          ;X += temp2;
    SUB R2  R2  R1          ;temp--;
    BP  R2  C0              ;if (temp) goto C0;
    BZ  R0  E1              ;
E0  LDA RB  0               ;X = 0;
E1  LDA R2  0x30            ;
    SUB R2  RC  R2          ;
    ADD RB  RB  R2          ;X = X + (i - 0x30);
    LDA R6  1               ;digit = 1;
    ST  RB  X               ;

    ADD RF  RE  R0          ;epilog
    LDI RE  RF              ;
    ADD RF  RF  R1          ;POP RE
    LDI RD  RF              ;POP return adress from stack
    ADD RF  RF  R1          ;
    JR  RD                  ;
                            ;}

;==============================================================
                            ;in main memory:
BUF     DUP 0x10            ;buffer
X       DW  3               ;int X;
N       DW  0x800A          ;int newline = 0x800A;
                            ;
                            ;CPU registers:
                            ;int R0 = 0;
                            ;int R1 = 1;
                            ;int R2 = temp;
                            ;int R3 = temp2;
                            ;int* R4 = buffer_ptr;
                            ;int R5 = halt;
                            ;int R6 = digit;
                            ;int RC = function return value int i
                            ;int RD = function return adress used by JL and JR
                            ;int RE = base pointer
                            ;int RF = stack pointer