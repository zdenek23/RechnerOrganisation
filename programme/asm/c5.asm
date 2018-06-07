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

    LDA R2  X               ;R2*X;
    SUB RF  RF  R1          ;
    STI R2  RF              ;parameter int* value;
    SUB RF  RF  R1          ;
    STI R1  RF              ;parameter newline = 1;
    JL  RD  PF              ;print() for testing
    LDA R2  2               ;get 2 parameter out of stack
    ADD RF  RF  R2          ;
    JL  RD  CV              ;
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
POL LD  R2  0xFE            ;check control register
    BZ  R2  POL             ;if control register is 0, goto POL    
    ST  R0  0xFE            ;reset control register to 0
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
;=============================================================
                            ;void save(){
SV  SUB RF  RF  R1          ;
    STI RD  RF              ;PUSH RD
    SUB RF  RF  R1          ;prolog
    STI RE  RF              ;PUSH RE
    ADD RE  RF  R0          ;initialize save() base pointer
                            ;
    LD  RB  X               ;
    STI RB  R4              ;*buffer_ptr = X;
    ADD R4  R4  R1          ;buffer_ptr++;
    LDA R6  0               ;digit = 0;

    ADD RF  RE  R0          ;epilog
    LDI RE  RF              ;
    ADD RF  RF  R1          ;POP RE
    LDI RD  RF              ;POP return adress from stack
    ADD RF  RF  R1          ;
    JR  RD                  ;
                            ;}
;=============================================================
                            ;in main memory:
BUF     DUP 0x10            ;buffer
X       DW  0               ;int X;
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