#include<stdio.h>

int i;
int X;
int digit;
int* buffer_ptr;
int halt;
int plus;
int multiplier;
int newline;
int temp;
int temp2;
int controller;

int buffer[16] = {0};

int main()
{
    i = 0;
    X = 0;
    digit = 0;
    buffer_ptr = buffer;
    halt = 0;
    plus = 9999;
    multiplier = 8888;
    newline = 7777;
    temp = 0;
    temp2 = 0;
    controller = 0;

A00:my_getchar();
    check_char();
    if (halt==0) goto A00;
    return 0;
}

void my_getchar()
{
    i = getchar();
}

void my_printf(int* value, int nl)
{
    printf("%d", *value);
    if (nl==0) goto D00;
    printf("%d", newline);
D00:;
}

void convert()
{
    if(digit==0) goto E00;
    temp = 10;
    temp2 = X;
    temp -= 1;
C00:X += temp2;
    temp--;
    if (temp>0) goto C00;
    goto E01;
E00:X = 0;
E01:X = X + (i - 0x30);
    digit = 1;
}

void save()
{
    *buffer_ptr = X;
    buffer_ptr++;
    digit = 0;
}

void add()
{
    buffer_ptr--;
    temp = *buffer_ptr;
    X += temp;
}

void multiply()
{
    buffer_ptr--;
    temp = *buffer_ptr;
    temp2 = X;
    temp -= 1;
B00:if (temp==0) goto B01;
    X += temp2;
    temp--;
    goto B00;
B01:;
}

void check_char()
{
    int result_ctrl = 0;
    int number_ctrl = 0;
    int nl_ctrl = 0;
    temp = 0x04;
    temp2 = controller - temp;
    if (temp2>0) goto G00;
    goto G01;
G00:result_ctrl = 1;
    controller -= temp;
    goto G02;
G01:if (temp2==0) goto G03;
    goto G02;
G03:result_ctrl = 1;
    controller -= temp;
G02:temp = 0x02;
    temp2 = controller - temp;
    if (temp2>0) goto H00;
    goto H01;
H00:number_ctrl = 1;
    controller -= temp;
    goto H02;
H01:if (temp2==0) goto H03;
    goto H02;
H03:number_ctrl = 1;
    controller -= temp;
H02:nl_ctrl = controller;
    controller = 0;
    temp = EOF;
    temp -= i;
    if (temp==0) goto F01;
    goto F02;
F01:my_printf(&newline, 0);
    halt = 1;
    goto F00;
F02:temp = 0x2f;
    temp = i - temp;
    if (temp>0) goto F03;
    goto F05;
F03:temp = 0x3a;
    temp -= i;
    if (temp>0) goto F04;
    goto F05;
F04:convert();
    number_ctrl = 1;
    goto F00;
F05:temp = 0x0a;
    temp -= i;
    if (temp==0) goto F06;
    goto F07;
F06:save();
    if (result_ctrl>0) goto F08;
    my_printf(&X, 1);
    goto F09;
F08:my_printf(&newline, 0);
F09:result_ctrl = 0;
    number_ctrl = 0;
    nl_ctrl = 1;
    goto F00;
F07:temp = 0x2b;
    temp -= i;
    if (temp==0) goto F0A;
    goto F0B;
F0A:if (number_ctrl==0) goto F0C;
    my_printf(&X, 0);
F0C:my_printf(&plus, 1);
    add();
    my_printf(&X, 0);
    result_ctrl = 1;
    nl_ctrl = 0;
    number_ctrl = 0;
    goto F00;
F0B:temp = 0x2a;
    temp -= i;
    if (temp==0) goto F0D;
    goto F00;
F0D:if (number_ctrl==0) goto F0E;
    my_printf(&X, 0);
F0E:my_printf(&multiplier, 1);
    multiply();
    my_printf(&X, 0);
    result_ctrl = 1;
    nl_ctrl = 0;
    number_ctrl = 0;
F00:if (result_ctrl>0) goto I00;
    goto I01;
I00:temp = 0x04;
    controller += temp;
I01:if (number_ctrl>0) goto J00;
    goto J01;
J00:temp = 0x02;
    controller += temp;
J01:if (nl_ctrl>0) controller++;
}

