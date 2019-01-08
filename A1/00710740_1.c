#include<stdio.h>

int i;
int X;
int test_number;
int pot = 10000;

int buffer[16] = {0};
int* buffer_ptr = buffer;

int out_num;

int digit = 0;
int wrote = 0;

int main() 
{
    while(1)
    {
        i = getchar();
        if(i==EOF)
        {
            putchar(0x0a);
            break;
        }
        putchar(i);
        if(i > 0x2f & i < 0x3a)
        {
            if(digit) X *= 10;
            else X = 0;
            X = X + (i - 0x30);
            digit = 1;
        }
        else if(i==0x0a)
        {
            *buffer_ptr++ = X;
            digit = 0;
        }
        else if(i==0x2b)
        {
            putchar(0x0a);
            X += *--buffer_ptr;
            test_number = X;
            while(1)
            {
                if(test_number > pot -1)
                {
                    if (test_number > 9999)
                    {
                        out_num = 6;
                    }
                    else
                    {
                        out_num = 9;
                    }
                    while(1)
                    {
                        if(test_number > pot * out_num -1)
                        {
                            putchar(out_num + 0x30);
                            test_number -= pot * out_num;
                            wrote = 1;
                            break;
                        }
                        out_num--;
                    }
                }
                else if(wrote == 1) putchar(0x30);
                if(pot>9999)pot = 1000;
                else if (pot>999) pot = 100;
                else if (pot>99) pot = 10;
                else
                {
                    putchar(test_number + 0x30);
                    wrote = 0;
                    pot = 10000;
                    break;
                }
            }
        }
    }
    return 0;
}