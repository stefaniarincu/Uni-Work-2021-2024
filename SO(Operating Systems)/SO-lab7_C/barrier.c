#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#define NTHREADS 5

sem_t sem;
pthread_mutex_t mtx;
int lock = 0;

void barrier_point()
{
	
   	if(pthread_mutex_lock(&mtx))
   	{
      		perror(NULL);
       	return;
        }
    	if(++lock == NTHREADS)
    	{
        	if(pthread_mutex_unlock(&mtx))
        	{
      			perror(NULL);
       		return;
        	}
        	if(sem_post(&sem))
        	{
      			perror(NULL);
       		return;
        	}
        	return;
    	}
    	if(pthread_mutex_unlock(&mtx))
    	{
      		perror(NULL);
       	return;
        }
    	if(sem_wait(&sem))
    	{
      		perror(NULL);
       	return;
        }
    	lock--;
    	if(sem_post(&sem))
    	{
      		perror(NULL);
       	return;
        }
}

void* init_thread(void *x)
{
    	int *tid = (int*)x;
    	printf("%d reached the barrier\n", *tid);
    	barrier_point();
    	printf("%d passed the barrier\n", *tid);
    	free(tid);
    	return NULL;
}

int main ()
{
	if(sem_init(&sem, 0, 0)) 
	{
		perror(NULL);
		return errno ;
	}
	if(pthread_mutex_init(&mtx, NULL)) 
	{
		perror(NULL);
		return errno;
	}
	printf("NTHREADS=%d\n", NTHREADS);
    	pthread_t *thr = malloc(NTHREADS*sizeof(pthread_t));
    	for(int i = 0; i < NTHREADS; i++)
        {
        	int *arg = malloc(sizeof(int));
        	*arg = i;
        	if(pthread_create(&thr[i], NULL, init_thread, arg))
        	{
        		perror(NULL);
        		return errno;
        	}
        }
    	for(int i = 0; i < NTHREADS; i++)
        	if(pthread_join(thr[i], NULL))
        	{
        		perror(NULL);
        		return errno;
        	}
        
        free(thr);
        sem_destroy(&sem);
	pthread_mutex_destroy(&mtx);
	return 0;
}
