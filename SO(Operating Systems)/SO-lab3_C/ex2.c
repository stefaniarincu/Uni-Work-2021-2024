#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int count_occurrences(const char* text, const char* word){
    int deReturnat = 0;
    int wordSize = strlen(word);
    while(1==1){
        text = strstr(text, word);
        if(text==NULL){
            break;
        }
        text+=wordSize;
        deReturnat++;
    }
    return deReturnat;
}

int main()
{  
    int count = count_occurrences("bla cevaa bla ", "bla");
    printf("%d \n", count);
    
    return 0;
}
