#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h> 
#include <sys/wait.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <string.h>

int main(int argc, char *argv[])
{
	if(argc < 2)
	{
		printf("Not enough arguments!\n");
		return -1;
	}
	int x, j, shm_fd;
	char shm_name[] = "shmcollatz";
	printf("Starting parent %d\n", getpid());
	shm_fd = shm_open(shm_name, O_CREAT|O_RDWR, S_IRUSR|S_IWUSR);
	if(shm_fd < 0) 
	{
		perror(NULL);
		return errno ;
	}
	size_t shm_size = argc * getpagesize();
	if(ftruncate(shm_fd, shm_size) == -1) 
	{
		perror(NULL);
		shm_unlink(shm_name);
		return errno ;
	}
	char *glob_var;
	glob_var = (char*)mmap(0, shm_size, PROT_READ, MAP_SHARED, shm_fd, 0);
	for(int i = 1; i < argc; i++)
	{
		x = atoi(argv[i]);	
		pid_t pid = fork();
		if(pid < 0)
			return errno ;
		else if( pid == 0)
		{
			char * shm_ptr;
			shm_ptr = (char*)mmap(0, getpagesize(), PROT_WRITE, MAP_SHARED, shm_fd, getpagesize() * (i - 1));
			if(shm_ptr == MAP_FAILED)
			{
				perror(NULL);
				shm_unlink(shm_name);
				return errno;
			}
			j = sprintf(shm_ptr, "%d: %d ", x, x);
			shm_ptr += j;
			while(x > 1)
			{
				if(x % 2 == 0) 
					x = x / 2;
				else
					x = 3 * x + 1;
				j = sprintf(shm_ptr, "%d ", x);
				shm_ptr += j;
			}
			printf("Done Parent %d Me %d\n", getppid(), getpid());
			munmap(shm_ptr, getpagesize());  	
			return 0;
		}
	}
	for(int i = 1; i < argc; i++)
		wait(NULL); 
	for(int i = 1; i < argc; i++)
		printf("%s\n", glob_var + (i - 1) * getpagesize());
	shm_unlink(shm_name);
	munmap(glob_var, sizeof *glob_var);
	printf("Done Parent %d Me %d\n", getppid(), getpid());
	return 0;
}
