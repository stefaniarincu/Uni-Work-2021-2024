#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>
int main(int argc, char *argv[])
{
	if(argc < 2)
	{
	 	printf("Not enough arguments!\n");
	 	return -1;
	}
	int x;
	printf("Starting parent %d\n", getpid());
	for(int i = 1; i < argc; i++){
		x = atoi(argv[i]);	
		pid_t pid = fork();
		if (pid < 0)
			return errno ;
		else if ( pid == 0){
			printf("%d: ", x);
			while(x > 1)
			{
				if(x % 2 == 0) 
					x = x / 2;
				else
					x = 3 * x + 1;
				printf("%d ", x);
			}	
			printf("\n");
			printf("Done Parent %d Me %d\n", getppid(), getpid());
			return 0;
		}
	}
	for(int i = 1; i < argc; i++)
		wait(NULL);
	printf("Done Parent %d Me %d\n", getppid(), getpid());
	return 0;
}
