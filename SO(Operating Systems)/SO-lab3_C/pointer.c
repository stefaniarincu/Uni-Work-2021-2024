#include <stdlib.h>
#include <stdio.h>
#include <string.h>
struct Book {
		int book_id;
		char title[50];
		char author[50];
		char subject[100];
	};
void printBook(struct Book *book) 
{
	printf("Book title: %s\n", book->title);
	printf("Book author: %s\n", book->author);
	printf("Book subject: %s\n", book->subject);
	printf("Book identifier: %d\n", book->book_id);
}

void main()
{
	int x, *a, b, *c;
	x = 23;
	a = &x;
	b = *a;
	c = a;
	printf("%d\t%d\t%d", x, *a, *c);
	printf("%x %x %x %x %x", &a, &b, &c, c, &x);
	
	int *p;
	p = p + 3;
	
	int n, *m, *k;
	n = 135;
	m = &n;
	k = m;
	(*m)++;
	*m++;
	printf("%d %d %x %p %x %x %x", *m, *k, m, m, k, &m, &k); 
	
	void *ptr = NULL;
	ptr = malloc(sizeof(int));
	*((int*)p) = 5;
	printf("%d\n", *((int*)p));
	
	int *p2, x2 = 100;
	p2 = &x2;
	
	char *p3 = "abc";
	
	struct Book *book_pointer, book1;
	book_pointer = &book1;
	book1.book_id = 2000;
	strcpy(book1.title, "Defence Against the Dark Arts");
	strcpy(book1.author, "Severus Snape");
	strcpy(book1.subject, "Defence Against the Dark Arts");
	printBook(&book1);	
}
