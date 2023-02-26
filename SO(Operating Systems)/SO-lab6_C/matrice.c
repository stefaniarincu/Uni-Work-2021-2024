#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h> 
#include <pthread.h>
#include <string.h>

int lin1, col1, lin2, col2, a[1000][1000], b[1000][1000], c[1000][1000];

void *mult(void *arg)
{
    int *coord = malloc(sizeof(int) * 2);
    coord = (int *)arg;
    int lin = coord[0], col = coord[1];
    for(int i = 0; i < col1; i++)
           c[lin][col] += a[lin][i] * b[i][col];
    free(coord);
    return NULL;
}

int main()
{
	printf("Numarul de linii si de coloane pentru prima matrice:\n");
	scanf("%d %d", &lin1, &col1);
	printf("Valorile din prima matrice:\n");
	for(int i = 0; i < lin1; i++)
		for(int j = 0; j < col1; j++)
			scanf("%d", &a[i][j]);
	printf("\n");
	lin2 = col1;
	printf("Numarul de coloane pentru a doua matrice (numarul de linii va fi egal cu numarul de coloane pentru prima):\n");
	scanf("%d", &col2);
	printf("Valorile din a doua matrice:\n");
	for(int i = 0; i < lin2; i++)
		for(int j = 0; j < col2; j++)
			scanf("%d", &b[i][j]);
	printf("\n");
	
	pthread_t thr[lin1 * col2];
	int k = 0;
	for(int i = 0; i < lin1; i++)
	{
		for(int j = 0; j < col2; j++)
		{
			int *coord = malloc(sizeof(int) * 2);
			coord[0] = i;
			coord[1] = j;
			if(pthread_create(&thr[k++], NULL, mult, (void*)coord))
			{
				perror(NULL);
				return errno;
			}
		}
	}
	for(int i = 0; i < k; i++)
		if(pthread_join(thr[i], NULL))
		{
			perror(NULL);
			return errno;
		}
	printf("Rezultatul inmultirii celor doua matrice:\n");
	for(int i = 0; i < lin1; i++)
	{
		for(int j = 0; j < col2; j++)
			printf("%d ", c[i][j]);
		printf("\n");
	}
	return 0;
}
