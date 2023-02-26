#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h> 
#include <sys/stat.h>

struct stat sb; 

int main(int argc, char **argv)
{
	if(argc < 3)
	{
		write(1, "Not enough arguments!\n",23);
		exit(0);
	}
	int f1 = open(argv[1], O_RDONLY);
	if (f1 == -1)
	{
		write(1, "Error opening file 1!\n",23);
		exit(0);
	}
	int f2 = open(argv[2], O_CREAT | O_WRONLY, S_IRWXU);
	if (f2 == -1)
	{
		write(1, "Error opening file 2!\n",23);
		close(f1);
		exit(0);
	}
	if(stat(argv[1], &sb)) 
        {
        	close(f1);
		close(f2);
            	write(1, "Error at file 1!\n", 18);
            	exit(0);
        }
	char* c = malloc(sb.st_size);
	read(f1, c, sb.st_size);
	write(f2, c, sb.st_size);
	write(1, "Completed!\n", 12);
	close(f1);
	close(f2);
	exit(0);
}
