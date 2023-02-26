#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>
int main()
{
	pid_t pid = fork();
	if (pid < 0)
		return errno;
	else if (pid == 0){
		printf (" First !");
		}
	else{
		wait ( NULL );
		printf (" Last !");
		}
	printf (" Parent %d Me %d \n " , getppid () , getpid ());
	return 0;
}

