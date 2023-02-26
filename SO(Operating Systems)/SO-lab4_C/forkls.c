#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>
int main()
{
	pid_t pid = fork ();
	if ( pid < 0)
		return errno ;
	else if ( pid == 0){
		printf ("My PID= %d, Child PID= %d \n " , getppid (), getpid());
		//primul argument e calea
		//aici nu am nevoie de alte arg, deci pun NULL deoarece lista trebuie sa se incheie cu NULL
		char * argv [] = {"ls" , NULL }; 
		//nu am nevoie de arg pt envp deci pun NULL
		execve ("/usr/bin/ls" , argv , NULL ); 
		//execve(2) nu mai revine in programul initial decat in cazul in care a aparut o eroare folosindu-se errno
		//pentru a determina cauza
		return errno;
		}
	else{
		wait(NULL);
		printf ("Child %d finished\n " , pid);
	    	}
	return 0;
}
