MAIN    LDA RF 0x40     ; initialize stack pointer
        LDA R1 1        ; initialize a constant with value 1
    
                        ; int main() {
                        ; "int a" lives at mem[RF] 

                        ; prolog
        PUSH RE         ; save old base pointer 
        ADD  RE RF R0   ; set base pointer of MAIN
        SUB  RF RF R1   ; make room for 1 local variable
                        ; end of prolog
        
        LDA  R3 7       ; create a 7 in R3
        ADD  RD RF R0   ; RD is address of "int a"
        STI  R3 RD      ; a = R3
        
        CALL SUB1       ; sub1();

        ADD  RD RF R0   ; RD is address of "int a"
        LDI  R2 RD      ; R2 = a
        ST   R2 0xFF    ; printf a

                        ; epilog
        ADD  RF RE R0   ; restore old stack pointer
        POP  RE         ; restore old base pointer
                        ; end of epilog
        HLT             ;}
;---------------------------------------------------------------
                        ;void sub1() {
                        ; "int a" lives at mem[RF] 
                        ; "int b" lives at mem[RF+1] 
                        ; "int c" lives at mem[RF+2] 
                         
SUB1    PUSH RE         ; prolog: save base pointer of caller
        ADD  RE RF R0   ; set base pointer of SUB1
        LDA  R2 3       ; SUB1 has 3 local variables
        SUB  RF RF R2   ; set stack pointer of SUB2 in order to have
                        ; a stack frame for SUB2 with room for 3 local variables
                        ; end of prolog

        ; b = 3
        LDA  R2 3       ; create value 3
        ADD  RD RF R1   ; RD <- RF + 1
        STI  R2 RD      ; b = 3;
        
        ; c = b;
        ADD  RD RF R1   ; RD <- address of "int b"
        LDI  R2 RD      ; R2 = b
        LDA  R3 2       
        ADD  RD RF R3   ; RD <- address of "int c"
        STI  R2 RD      ; c = R2

        ; a = c;
        LDA  R3 2       
        ADD  RD RF R3   ; RD <- address of "int c"
        LDI  R2 RD      ; R2 = c
        ADD  RD RF R0   ; RD <- address of "int c"
        STI  R2 RD      ; a = R2

        LDI  R2 RF      ; R2 = a
        ST   R2 0xFF    ; printf a
        
        ADD  RF RE R0   ; epilog: restore previous stack pointer
        POP  RE         ; restore base pointer of caller
        RET             ;}
        