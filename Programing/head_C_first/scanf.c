#include <stdio.h>

int main()
{
    char s1[20], s2[20];
    scanf("%s\n", s1); // input many string
    // In C, scanf doesn't return the data it reads. Instead, it returns the count of successfully filled items.
    fgets(s1, sizeof(s1), stdin);
    fgets(s2, sizeof(s2), stdin);
    printf("%s\n%s", s1, s2); // input many string
}
