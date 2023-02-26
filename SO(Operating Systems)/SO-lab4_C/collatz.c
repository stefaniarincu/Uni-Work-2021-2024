#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>
int main(int argc, char *argv[])
{
	if(argc < 2)
	{
		printf("Nu sunt suficiente argumente!\n");
		return -1;
	}
	int x = atoi(argv[1]);	
	pid_t pid = fork();
	if (pid < 0)
		return errno ;
	else if ( pid == 0){
		printf("Pid copil: %d\n", pid);
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
		return 0;
		}
	else{
		wait(NULL);
		printf ("Child %d finished\n", pid);
	    	}
	return 0;
}
