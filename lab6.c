#include <stdio.h>
#include <stdbool.h>

unsigned int read_integer(void)
{
    unsigned int n;
    scanf("%u",&n);
    return n;
}

void print_prime(void)
{
    printf("prime\n");
}

void print_not_prime(void)
{
    printf("not prime\n");
}

int main(void)
{
    unsigned int i;
    unsigned int n=read_integer();
    bool is_prime;

	main_loop:
    if (n==0)
		goto done_main;
    
        if (n!=1) 
			goto not_1;
            print_not_prime();
			goto done_1;
        not_1:
            is_prime=true;
			i=2;
			loop:
            if (i*i>n) 
				goto break_loop;
                if ((n%i)!=0) 
					goto not_div;
                    is_prime=false;
                    goto break_loop;
				not_div:
				i++;
				goto loop;
			break_loop:
            if (!is_prime) 
				goto not_prime;
                print_prime();
				goto done_prime;
            not_prime:
                print_not_prime();
			done_prime:
        done_1:
        n=read_integer();
		goto main_loop;
    done_main:
		return 0;
}
