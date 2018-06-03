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
int RC;
int RD;
int RE;

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
    RC = 0;
    RD = 0;
    RE = 0;

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
    RD = 10;
    RE = R3;
    RD -= 1;
C00:R3 += RE;
    RD--;
    if (RD>0) goto C00;
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
    RD = *R5;
    R3 += RD;
}

void multiply()
{
    R5--;
    RD = *R5;
    RE = R3;
    RD -= 1;
B00:if (RD==0) goto B01;
    R3 += RE;
    RD--;
    goto B00;
B01:;
}

void check_char()
{
    RD = EOF;
    RD -= R2;
    if (RD==0) goto F01;
    goto F02;
F01:my_printf(&R9, 0);
    R6 = 1;
    goto F00;
F02:RD = 0x2f;
    RD = R2 - RD;
    if (RD>0) goto F03;
    goto F05;
F03:RD = 0x3a;
    RD -= R2;
    if (RD>0) goto F04;
    goto F05;
F04:convert();
    RB = 1;
    goto F00;
F05:RD = 0x0a;
    RD -= R2;
    if (RD==0) goto F06;
    goto F07;
F06:save();
    if (RA>0) goto F08;
    my_printf(&R3, 1);
    goto F09;
F08:my_printf(&R9, 0);
F09:RA = 0;
    RB = 0;
    RC = 1;
    goto F00;
F07:RD = 0x2b;
    RD -= R2;
    if (RD==0) goto F0A;
    goto F0B;
F0A:if (RB==0) goto F0C;
    my_printf(&R3, 0);
F0C:my_printf(&R7, 1);
    add();
    my_printf(&R3, 0);
    RA = 1;
    RC = 0;
    RB = 0;
    goto F00;
F0B:RD = 0x2a;
    RD -= R2;
    if (RD==0) goto F0D;
    goto F00;
F0D:if (RB==0) goto F0E;
    my_printf(&R3, 0);
F0E:my_printf(&R8, 1);
    multiply();
    my_printf(&R3, 0);
    RA = 1;
    RC = 0;
    RB = 0;
F00:;
}

