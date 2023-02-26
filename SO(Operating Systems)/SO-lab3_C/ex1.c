#include <stdlib.h>
#include <stdio.h>
int n, x;
int **mat;

int main()
{
	scanf("%d", &n);
	mat = malloc(n * sizeof(int *));
	for(int i = 0; i < n; i++)
		mat[i] = malloc(n * sizeof(int));
	for(int i = 0; i < n; i++)
		for(int j = 0; j < n; j++)	
			scanf("%d", &mat[i][j]);
	for(int i = 0; i < n; i++)
	{
		for(int j = 0; j < n; j++)	
			printf("%d ", mat[i][j]);
		printf("\n");
	}
	if(n % 2 == 1) 
	{
		x = n / 2;
		printf("%d", mat[x][x]);
		printf("\n");
	}
	for(int i = 0; i < n; i++)
		printf("%d ", mat[i][i]);
	printf("\n");
	for(int i = 0; i < n; i++)
		printf("%d ", mat[i][n-i-1]);
	printf("\n");
}

