#include<stdio.h>

int i;
int X = 1;
int digit = 0;
int buffer[16] = {0};
int* buffer_ptr = buffer;
int halt = 0;
int plus = 9999;
int multiplyer = 8888;
int newline = 7777;
int result_ctrl = 0;
int number_ctrl = 0;
int nl_ctrl = 0;

void my_getchar()
{
    i = getchar();
}

void my_printf(int* value, int nl)
{
    printf("%d", *value);
    if (nl) printf("%d", newline);
}

void convert()
{
    if(digit) X *= 10;
    else X = 0;
    X = X + (i - 0x30);
    digit = 1;
}

void save()
{
    *buffer_ptr++ = X;
    digit = 0;
}

void add()
{
    X += *--buffer_ptr;
}

void multiply()
{
    X *= *--buffer_ptr;
}

void check_char()
{
    if (i==EOF)
    {
        halt = 1;
    }
    else if (i > 0x2f & i < 0x3a)
    {
        convert();
        number_ctrl = 1;
    }
    else if (i==0x0a)
    {
        save();
        if (result_ctrl == 0) my_printf(&X, 1);
        result_ctrl = 0;
        number_ctrl = 0;
        nl_ctrl = 1;
    }
    else if (i==0x2b)
    {
        if (number_ctrl>0) my_printf(&X, 0);
        else if (result_ctrl>0) my_printf(&X, 0);
        my_printf(&plus, 1);
        add();
        my_printf(&X, nl_ctrl);
        result_ctrl = 1;
        nl_ctrl = 0;
    }
    else if (i==0x2a)
    {
        if (number_ctrl>0) my_printf(&X, 0);
        else if (result_ctrl>0) my_printf(&X, 0);
        my_printf(&multiplyer, 1);
        multiply();
        my_printf(&X, 1);
        result_ctrl = 1;
    }
}

int main()
{
    while(1)
    {
        my_getchar();
        check_char();
        if (halt) break;
    }
    return 0;
}