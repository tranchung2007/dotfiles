#include <stdio.h>

void fortune_cookie(char *msg)
{
    printf("Message reads: %s\n", msg);
    printf("Message reads: %p\n", msg);
    printf("size of Message func is: %d\n\n", sizeof(msg)); // sizeof msg pointer *msg
}

int main(void)
{
    char quote[] = "Cookies make you fk fat";
    fortune_cookie(quote);
    printf("size of Message main is: %d\n", sizeof(quote));
    printf("Message reads in main: %p\n", quote);
    printf("%s", quote + 8); // print after "Cookies"
    return 0;
}
