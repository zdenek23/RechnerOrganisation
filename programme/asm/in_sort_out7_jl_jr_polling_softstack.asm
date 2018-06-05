;//*********************************************
;// Get values from stdin
;// Sort values with bubblesort
;// Print sorted values to stdout
;//
;// KC Posch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RF is stack pointer
; RD holds recent return address
;
; 0xFF mapped to DR of stdin
; 0xFE mapped to CR of stdin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;//*********************************************

                        ;#include <stdio.h>
;=====================================================
                        ;int main() {
    LDA RF  0xE0        ;   initialize stack pointer
    
    LDA R1  1           ;   R1 = 1;
    LDA R4  A           ;   R4 = array;
    ST  R4  ARP         ;   arp = R4;

    JL	RD	LL0					;CALL  LL0           ;read_from_stdin();
		;JL	RD	PS					;   CALL  PS            ;print_to_stdout();       
    JL	RD	BS					;CALL  BS            ;bubblesort();
    JL	RD	PS					;CALL  PS            ;print_to_stdout();
    HLT                 ;}

;===========================================================
                        ;void read_from_stdin() {
LL0 SUB	RF	RF	R1			; prolog
		STI	RD	RF
		
LL2	LD  R5  0xFE        ;   check control register
    BZ  R5  LL2         ;   if control register is 0, goto LL2    
    LD  R2  0xFF        ;   scanf("%x", &length);
    ST  R0  0xFE        ;   reset control register to 0
    
    ST  R2  L

    ST  R0  I           ;   i = R0;     //i = 0;
    BZ  R0  L0          ;   goto L0;

L1  LD  R4  ARP         ;L1: R4 = arp;
    LD  R2  I           ;   R2 = i;
    ADD R4  R4  R2      ;   R4 = R4 + R2;
    ST  R4  ARPJ        ;   arpj = R4;
    LD  R4  ARPJ        ;   (scanf("%x", arpj);)

LL1 LD  R5  0xFE        ;   check control register
    BZ  R5  LL1         ;   if control register is 0, goto LL1
    LD  R2  0xFF        ;   scanf("%x", arpj);
    ST  R0  0xFE        ;   reset control register
    STI R2  R4

    LD  R2  I           ;   R2 = i;
    ADD R2  R2  R1      ;   R2 = R2 + R1;
    ST  R2  I           ;   i  = R2;

L0  LD  R2  L           ;   L0: R2 = length;
    LD  R3  I           ;   R3 = i;
    SUB R2  R2  R3      ;   R2 = R2 - R3;
    ST  R2  T           ;   temp = R2;
    LD  R2  T           ;   R2 = temp;
    BP  R2  L1          ;   if (R2 > 0) goto L1;
    
    LDI	RD	RF					;RET                 ;}
    ADD	RF	RF	R1
    JR	RD                      

;===========================================================
                        ;void print_to_stdout() {   
PS  SUB	RF	RF	R1			; prolog
		STI	RD	RF
		
		ST  R0  I           ;   i = R0; //i = 0;
    BZ  R0  L8          ;   goto L8;
L9  LD  R4  ARP         ;L9: R4 = arp;
    LD  R2  I           ;   R2 = i;
    ADD R4  R4  R2      ;   R4 = R4 + R2;
    ST  R4  ARPJ        ;   arpj = R4;
    
    LD  R4  ARPJ        ;   printf("%x ", *arpj);
    LDI R2  R4    
    ST  R2  0xFF
                        ;   //i++;
    LD  R2  I           ;   R2 = i;
    ADD R2  R2  R1      ;   R2 = R2 + R1;
    ST  R2  I           ;   i = R2;
L8  LD  R2  L           ;L8: R2 = length;
    LD  R3  I           ;   R3 = i;
    SUB R2  R2  R3      ;   R2 = R2 - R3;
    ST  R2  T           ;   temp = R2;  
    LD  R2  T           ;   R2 = temp;
    BP  R2  L9          ;   if (R2 > 0) goto L9;
                        ;   printf("\n"); // print 0000

    LDI	RD	RF					;RET                 ;}
    ADD	RF	RF	R1
    JR	RD                      

;===========================================================
                        ;void bubblesort() {
BS  SUB	RF	RF	R1			; prolog
		STI	RD	RF
		
		LD  R2  L           ;   R2 = length;
    ST  R2  I           ;   i  = R2;
    BZ  R0  L4          ;   goto L4;
L5  ST  R1  J           ;L5: j = R1;    //j = 1;
    BZ  R0  L6          ;   goto L6;
L7  LD  R4  ARP         ;L7: R4 = arp;
    LD  R2  J           ;   R2 = j;
    ADD R4  R4  R2      ;   R4 = R4 + R2;
    ST  R4  ARPJ        ;   arpj = R4;
    LD  R4  ARP         ;   R4 = arp;
    LD  R2  J           ;   R2 = j;
    ADD R4  R4  R2      ;   R4 = R4 + R2;
    SUB R4  R4  R1      ;   R4 = R4 - R1;
    ST  R4  ARPJM1      ;   arpjm1 = R4;
    LD  R4  ARPJ        ;   R2 = *arpj;
    LDI R2  R4
    ST  R2  ARJ         ;   arj = R2;
    LD  R4  ARPJM1      ;   R2 = *arpjm1;
    LDI R2  R4  
    ST  R2  ARJM1       ;   arjm1 = R2;
    LD  R2  ARJ         ;   R2 = arj;
    LD  R3  ARJM1       ;   R3 = arjm1;
    SUB R2  R2  R3      ;   R2 = R2 - R3;
    ST  R2  T           ;   temp = R2;
    LD  R2  T           ;   R2 = temp;
    BP  R2  L10         ;   if (R2 > 0) goto L10;
    LD  R2  T           ;   R2 = temp;
    BZ  R2  L10         ;   if (R2 == 0) goto L10;
    LD  R2  ARJM1       ;   R2 = arjm1;
    LD  R4  ARPJ        ;   *arpj = R2;
    STI R2  R4 
    LD  R2  ARJ         ;   R2 = arj;
    LD  R4  ARPJM1      ;   *arpjm1 = R2;
    STI R2  R4
L10 LD  R2  J           ;L10: R2 = j;
    ADD R2  R2  R1      ;   R2 = R2 + R1;
    ST  R2  J           ;   j = R2;
L6  LD  R2  I           ;L6: R2 = i;
    LD  R3  J           ;   R3 = j;
    SUB R2  R2  R3      ;   R2 = R2 - R3;
    ST  R2  T           ;   temp = R2;
    LD  R2  T           ;   R2 = temp;
    BP  R2  L7          ;   if (R2 > 0) goto L7;
    LD  R2  I           ;  R2 = i;
    SUB R2  R2  R1      ;  R2 = R2 - R1;
    ST  R2  I           ;  i = R2;
L4  LD  R2  I           ;L4: R2 = i;
    SUB R2  R2  R1      ;   R2 = R2 - R1;
    ST  R2  T           ;   temp = R2;
    LD  R2  T           ;   R2 = temp;
    BP  R2  L5          ;   if (R2 > 0) goto L5;

    LDI	RD	RF					;RET                 ;}
    ADD	RF	RF	R1
    JR	RD                      
    
;===========================================================    
                        ;// in main memory:
L       DW  0         
I       DW  0           
J       DW  0           
T       DW  0           
ARP     DW  0           
ARPJ    DW  0           
ARPJM1  DW  0           
ARJ     DW  0           
ARJM1   DW  0               
A       DUP 16          
