#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h> 
#include <pthread.h>
#include <string.h>

void *reverse(void *v)
{
	char *s = (char *)v;
	char *rs = malloc(sizeof(char) * strlen(s));
	int k = 0;
	for(int i = strlen(s) - 1; i >= 0; i--)
	{
		rs[k] = s[i];
		k++;
	}
	return rs;
}

int main(int argc, char *argv[])
{
	if(argc < 2)
	{
		printf("Not enough arguments!\n");
		return -1;
	}
	char *c = argv[1];
	pthread_t thr;
	if(pthread_create(&thr, NULL, reverse, (void *)c))
	{
		perror(NULL);
		return errno;
	}
	void *rev_str;
	//rev_str primeste rezultatul functiei reverse
	if(pthread_join(thr, &rev_str)) 
	{
		perror(NULL);
		return errno;
	}
	printf("%s\n", (char*) rev_str);
	free(rev_str);
	return 0;
}
