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

char* replace_occurrances(const char* text, const char* word, const char* word2){
    int aparitii=count_occurrences(text, word);
    
    char* textNou = malloc(sizeof(char)*(strlen(text)-strlen(word)*aparitii+strlen(word2)*aparitii));

    int wordSize = strlen(word);
    int wordSize2 = strlen(word2);
    int offset=0;
    for(int i=0;i<aparitii;i++){
        char* poz = strstr(text, word);
        int offsetLocal = poz-text;
        //printf("offset: %d\n", offsetLocal);
        strncpy(textNou+offset, text, offsetLocal);
        offset+=offsetLocal;
        text=poz+wordSize;
        strcpy(textNou+offset, word2);
        offset+=wordSize2;
    }
    strcpy(textNou+offset, text);
    return textNou;
}


int main()
{   
    int count = count_occurrences("bla cevaa bla ", "bla");
    printf("%d \n", count);
    
    printf("%s \n", replace_occurrances("test test test", "test", "t"));
    
    return 0;
}
