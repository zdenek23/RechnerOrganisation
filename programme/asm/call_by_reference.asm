MAIN    LDA RF 0x50     ; initialize stack pointer
        LDA R1 1        ; initialize constant 1
        
                        ;int main() {
                        ; mem[RF]       ;int a;
                        ; mem[RF+1]     ;int b;
        PUSH RE         ; prolog: save base pointer
        ADD  RE RF R0   ; set base pointer of MAIN
        LDA  R2 2       ; MAIN has 2 local int variables
        SUB  RF RF R2   ; set new stack pointer

        LDA  R2 3       ;   a = 3;
        STI  R2 0 RF

        LDA  R2 4       ;   b = 4;
        STI  R2 1 RF

        LDI  R2 0 RF
        ST   R2 0xFF    ; print a

        LDI  R2 1 RF
        ST   R2 0xFF    ; print b
                    
        ADD  R2 RF R1   ; get parameter "&b" into R2
        ADD  R3 RF R0   ; get parameter "&a" into R3
        PUSH R2         ; push parameter "&b"
        PUSH R3         ; push parameter "&a"
        CALL SWAP       ; swap(&a, &b);
        LDA  R2 2       ; get 2 parameters out of stack
        ADD  RF RF R2  

        LDI  R2 0 RF
        ST   R2 0xFF    ; print a

        LDI  R2 1 RF
        ST   R2 0xFF    ; print b

        ADD  RF RE R0   ; epilog: restore old stack pointer
        POP  RE         ; restore old base pointer
        HLT             ;}

;--------------------------------------------------------------
SWAP    PUSH RE         ; prolog
        ADD  RE RF R0
        LDA  R2 1
        SUB  RF RF R2
                        ;void swap(int *x, int *y) {
                        ;mem[RF]    ;int temp;
 
                        ;temp = *x;
        LDI  R2 2 RE    ; get parameter "address of x" ("&x") into R2
        LDI  R3 0 R2    ; dereference R2: value at address x is now in R3
        STI  R3 0 RF    ; store y on stack ("temp")
            
                        ;*x = *y;
        LDI  R4 3 RE    ; get parameter "addres of y" ("&y") in to R4
        LDI  R3 0 R4    ; dereference R4: value at address of y is now in R3
        STI  R3 0 R2    ; store value at address of y at address of x
            
                        ;*y = temp; 
        LDI  R3 0 RF    ; copy temp from stack and store in R3
        STI  R3 0 R4    ; store copy of temp at "address of y"

        ADD  RF RE R0   ; epilog
        POP  RE
        RET             ;}
