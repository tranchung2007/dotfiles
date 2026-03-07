#include <stdio.h>
#include <string.h>

void reverse_str(char *s)
{
    size_t len = strlen(s);
    char *t = s + len - 1; // pointer point to the end character of string s
    while (t >= s) {
        printf("%c", *t);
        t--;
    }
    puts(""); // endline :((
}

int main(int argc, char **argv)
{
    char first[] = "Hello World!";
    reverse_str(first);
    printf("%d\n", argc);
    for (int i = 0; i < argc; ++i) {
        printf("%s\n", argv[i]);
    }
}
