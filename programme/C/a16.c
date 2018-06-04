#include<stdio.h>

int R2;
int R3;
int R4;
int* R5;
int R6;
int R7;
int R8;
int R9;
int RA;
int RB;
int RD;

int buffer[16] = {0};

int main()
{
    R2 = 0;
    R3 = 0;
    R4 = 0;
    R5 = buffer;
    R6 = 0;
    R7 = 9999;
    R8 = 8888;
    R9 = 7777;
    RA = 0;
    RB = 0;
    RD = 0;

A00:my_getchar();
    check_char();
    if (R6==0) goto A00;
    return 0;
}

void my_getchar()
{
    R2 = getchar();
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

