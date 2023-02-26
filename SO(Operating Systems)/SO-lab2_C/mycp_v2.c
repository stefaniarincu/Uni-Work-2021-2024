#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h> 
#include <sys/stat.h>
#include <errno.h>

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
		perror("Error opening file 1!\n");
		return errno;
	}
	int f2 = open(argv[2], O_CREAT | O_WRONLY, S_IRWXU);
	if (f2 == -1)
	{
		close(f1);
		perror("Error opening file 2!\n");
		return errno;
	}
	if(stat(argv[1], &sb)) 
        {
        	close(f1);
		close(f2);
            	perror("Error at file 1!\n");
            	return errno;
        }
	char* c = malloc(sb.st_size);
	read(f1, c, sb.st_size);
	write(f2, c, sb.st_size);
	write(1, "Completed!\n", 12);
	close(f1);
	close(f2);
	exit(0);
}
