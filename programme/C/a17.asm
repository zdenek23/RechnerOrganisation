                            ;#include<stdio.h>
                            ;
                            ;int R1;
                            ;int R2;
                            ;int R3;
                            ;int R4;
                            ;int* R5;
                            ;int R6;
                            ;int R7;
                            ;int R8;
                            ;int R9;
                            ;int RA;
                            ;int RB;
                            ;int RD;
                            ;
BUF DUP 0x10                ;int buffer[16] = {0};
                            ;
                            ;int main()
                            ;{
MAIN LDA RF  0xF0        ;initialize stack-pointer
     LDA R1  0x01        ;R1=1;
     ADD R2  R0  R0      ;R2 = 0;
     ADD R3  R0  R0      ;R3 = 0;
     ADD R4  R0  R0      ;R4 = 0;
     LDA RA  BUF         ;R5 = buffer;
     ADD R6  R0  R0      ;R6 = 0;
     LDA R7  0x802B      ;R7 = 0x802B;
     LDA R8  0x802A      ;R8 = 0x802A;
     LDA R9  0x800A      ;R9 = 0x800A;
     ADD RA  R0  R0      ;RA = 0;
     ADD RB  R0  R0      ;RB = 0;
     ADD RD  R0  R0      ;RD = 0;
                            ;
A00 JL  RE  LL0             ;A00:my_getchar();
    JL  RE  CC              ;check_char();
    BZ  R6  A00             ;if (R6==0) goto A00;
    HLT                     ;return 0;
                            ;}

                            ;polling routine
POL LD  RA  0xFE            ;check control register
    BZ  RA  POL             ;if control register is 0, goto POL
    ST  R0  0xFE            ;reset control register to 0
    JR  RE                  ;return

                            ;void my_getchar()
                            ;{
CC  SUB RF  RF  R1          ;increase the stack by 1 position
    STI RE  RF              ;push RE
    JL  RE  POL             
    LD  R2  0xFF            ;R2 = getchar();
}

void my_printf(int* value, int nl)
{
    printf("%d", *value);
    if (nl==0) goto D00;
    printf("%d", R9);
D00:;
}

void convert()
{
    if(R4==0) goto E00;
    RA = 10;
    RB = R3;
    RA -= 1;
C00:R3 += RB;
    RA--;
    if (RA>0) goto C00;
    goto E01;
E00:R3 = 0;
E01:R3 = R3 + (R2 - 0x30);
    R4 = 1;
}

void save()
{
    *R5 = R3;
    R5++;
    R4 = 0;
}

void add()
{
    R5--;
    RA = *R5;
    R3 += RA;
}

void multiply()
{
    R5--;
    RA = *R5;
    RB = R3;
    RA -= 1;
B00:if (RA==0) goto B01;
    R3 += RB;
    RA--;
    goto B00;
B01:;
}

void check_char()
{
    int result_ctrl = 0;
    int number_ctrl = 0;
    int nl_ctrl = 0;
    RA = 0x04;
    RB = RD - RA;
    if (RB>0) goto G00;
    goto G01;
G00:result_ctrl = 1;
    RD -= RA;
    goto G02;
G01:if (RB==0) goto G03;
    goto G02;
G03:result_ctrl = 1;
    RD -= RA;
G02:RA = 0x02;
    RB = RD - RA;
    if (RB>0) goto H00;
    goto H01;
H00:number_ctrl = 1;
    RD -= RA;
    goto H02;
H01:if (RB==0) goto H03;
    goto H02;
H03:number_ctrl = 1;
    RD -= RA;
H02:nl_ctrl = RD;
    RD = 0;
    RA = EOF;
    RA -= R2;
    if (RA==0) goto F01;
    goto F02;
F01:my_printf(&R9, 0);
    R6 = 1;
    goto F00;
F02:RA = 0x2f;
    RA = R2 - RA;
    if (RA>0) goto F03;
    goto F05;
F03:RA = 0x3a;
    RA -= R2;
    if (RA>0) goto F04;
    goto F05;
F04:convert();
    number_ctrl = 1;
    goto F00;
F05:RA = 0x0a;
    RA -= R2;
    if (RA==0) goto F06;
    goto F07;
F06:save();
    if (result_ctrl>0) goto F08;
    my_printf(&R3, 1);
    goto F09;
F08:my_printf(&R9, 0);
F09:result_ctrl = 0;
    number_ctrl = 0;
    nl_ctrl = 1;
    goto F00;
F07:RA = 0x2b;
    RA -= R2;
    if (RA==0) goto F0A;
    goto F0B;
F0A:if (number_ctrl==0) goto F0C;
    my_printf(&R3, 0);
F0C:my_printf(&R7, 1);
    add();
    my_printf(&R3, 0);
    result_ctrl = 1;
    nl_ctrl = 0;
    number_ctrl = 0;
    goto F00;
F0B:RA = 0x2a;
    RA -= R2;
    if (RA==0) goto F0D;
    goto F00;
F0D:if (number_ctrl==0) goto F0E;
    my_printf(&R3, 0);
F0E:my_printf(&R8, 1);
    multiply();
    my_printf(&R3, 0);
    result_ctrl = 1;
    nl_ctrl = 0;
    number_ctrl = 0;
F00:if (result_ctrl>0) goto I00;
    goto I01;
I00:RA = 0x04;
    RD += RA;
I01:if (number_ctrl>0) goto J00;
    goto J01;
J00:RA = 0x02;
    RD += RA;
J01:if (nl_ctrl>0) RD++;
}

