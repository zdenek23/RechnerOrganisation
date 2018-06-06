                            ;include <stdio.h>

;=============================================================
                            ;int main(){
                            ;
MAIN LDA RF 0xF0            ;initialize stack pointer
     ADD RE RF  R0          ;initialize MAIN base pointer
     LDA R1 1               ;constant 1
     LDA R4 BUF             ;int* buffer;
                            ;
A0  JL  RD  LL0             ;A0:getchar();

    LDA R2  T               ;R2* = T;
    SUB RF  RF  R1          ;
    STI R2  RF              ;parameter int* value;
    SUB RF  RF  R1          ;
    STI R1  RF              ;parameter newline = 1;
    JL  RD  PF              ;print() for testing
    LDA R2  2               ;get 2 parameter out of stack
    ADD RF  RF  R2          ;
                            ;check_char();
    BZ  R5  A0              ;if (halt==0) goto A00;
    
    ADD RF  RE  R0          ;epilog: restore old stack pointer
    LDI RE  RF              ;restore old base pointer
    HLT                     ;return 0;
                            ;}
                            ;
;=============================================================
; polling routine: return address in RD,
;                  returns no value:
POL LD  R2  0xFE        ;   check control register
    BZ  R2  POL         ;   if control register is 0, goto POL    
    ST  R0  0xFE        ;   reset control register to 0
    JR  RD

;=============================================================
                            ;getchar(){
LL0 SUB RF  RF  R1          ;
    STI RD  RF              ;PUSH RD
    SUB RF  RF  R1          ;prolog
    STI RE  RF              ;PUSH RE
    ADD RE  RF  R0          ;initialize getchar() base pointer
                            ;
    JL  RD  POL             ;CALL polling routine    
    LD  RC  0xFF            ;read from stdin
    LDA R2  3               ;R2 = EOF;
    SUB R2  R2  RC          ;temp = EOF - RC
    BZ  R2  F1              ;if (RC==EOF) goto F1
    BZ  R0  F2              ;goto F2
F1  ADD R5  R1  R0          ;halt = 1;
                            ;
F2  ADD RF  RE  R0          ;epilog
    LDI RE  RF              ;
    ADD RF  RF  R1          ;POP RE
    LDI RD  RF              ;POP return adress from stack
    ADD RF  RF  R1          ;
    JR  RD                  ;
                            ;

;=============================================================
                            ;printf(int* value, int newline){
PF  SUB RF  RF  R1          ;
    STI RD  RF              ;PUSH RD
    SUB RF  RF  R1          ;prolog
    STI RE  RF              ;PUSH RE
    SUB RE  RE  R1          ;
    LDI R2  RE              ;R2 = &value;
    SUB RE  RE  R1          ;R3 = newline;
    LDI R3  RE              ;
    ADD RE  RF  R0          ;initialize printf() base pointer
    SUB RF  RF  R1          ;PUSH &value as local variable
    STI R2  RF              ;
    SUB RF  RF  R1          ;PUSH newline as local variable
    STI R2  RF              ;

    JL  RD  POL             ;CALL polling routine
    ADD RF  RF  R1          ;
    LDI R2  RF              ;R2 = &value;
    SUB RF  RF  R1          ;
    LDI R2  R2              ;R2 = value;
    ST  R2  0xFF            ;printf("%d", *value);
    LDI R2  RF              ; 
    BZ  R2  D0              ;if (nl==0)
    JL  RD  POL             ;CALL polling routine
    LDA R2  N               ;R2 = newline;
    LDI R2  R2              ; 
    ST  R2  0xFF            ;
                            ;
D0  ADD RF  RE  R0          ;epilog
    LDI RE  RF              ;
    ADD RF  RF  R1          ;POP RE
    LDI RD  RF              ;POP return adress from stack
    ADD RF  RF  R1          ;
    JR  RD                  ;
                            ;}

;=============================================================
                            ;in main memory:
BUF     DUP 0x10            ;buffer
T       DW  0xE35           ;int test;
N       DW  0x800A          ;int newline = 0x800A;
                            ;
                            ;CPU registers:
                            ;int R0 = 0;
                            ;int R1 = 1;
                            ;int R2 = temp;
                            ;int R3 = temp2;
                            ;int* R4 = buffer_ptr;
                            ;int R5 = halt;
                            ;int RC = function return value
                            ;int RD = function return adress used by JL and JR
                            ;int RE = base pointer
                            ;int RF = stack pointer