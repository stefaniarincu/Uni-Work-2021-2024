#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
int main()
{
	write(1, "Hello, World!\n", 16);
	exit(0);
}
