#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h> 
#include <pthread.h>
#include <string.h>

#define MAX_RESOURCES 5
#define NTHREADS 10

pthread_mutex_t mtx;
int available_resources = MAX_RESOURCES;
int vect[NTHREADS] = {-2, 2, -2, 2, -1, 1, -3, -2, 3, 2};

int decrease_count(int count)
{
	int lock = pthread_mutex_lock(&mtx);
	if(lock)
	{
		perror(NULL);
		return errno;
	}
    	if(count <= available_resources)
           	available_resources -= count;
    	else 
        	return pthread_mutex_unlock(&mtx);
    	int local = available_resources;
     	if(pthread_mutex_unlock(&mtx))
     	{
     		perror(NULL);
     		return errno;
     	}
     	return local;
}

int increase_count(int count)
{
	int lock = pthread_mutex_lock(&mtx);
	if(lock)
	{
		perror(NULL);
		return errno;
	}
    	if(available_resources + count <= MAX_RESOURCES)
           	available_resources += count;
    	else
        	return pthread_mutex_unlock(&mtx);
    	int local = available_resources;
     	if(pthread_mutex_unlock(&mtx))
     	{
     		perror(NULL);
     		return errno;
     	}
     	return local;
}

void* init_thread(void *x){
    	int cnt = *((int*)x);
    	int var;
    	if(cnt < 0)
    	{
    		var = decrease_count(-cnt);
		printf("Got %d resources, %d remaining\n", -cnt, var);
	}	
   	else
   	{
        	var = increase_count(cnt);
        	printf("Released %d resources, %d remaining\n", cnt, var);
        }
    	return NULL;
}

int main ()
{
	if(pthread_mutex_init(&mtx, NULL)) 
	{
		perror(NULL);
		return errno;
	}
	printf("MAX_RESOURCES=%d\n", MAX_RESOURCES);
    	pthread_t *thr = malloc(NTHREADS * sizeof(pthread_t));
    	for(int i = 0; i < NTHREADS; i++)
        	if(pthread_create(&thr[i], NULL, init_thread, &vect[i]))
        	{
        		perror(NULL);
        		return errno;
        	}
    	for(int i = 0; i < NTHREADS; i++)
        	if(pthread_join(thr[i], NULL))
        	{
        		perror(NULL);
        		return errno;
        	}
        free(thr);
	pthread_mutex_destroy(&mtx);
	return 0;
}
