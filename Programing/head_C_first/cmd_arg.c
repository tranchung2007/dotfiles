#include <stdio.h>
#include <unistd.h>

// idk how it work :((
int main(int argc, char **argv)
{
    char ch;
    while ((ch = getopt(argc, argv, "a t")) != EOF)
    {
        switch (ch) {
        case 'a':
            printf("Foo\n");
            break;
        case 't':
            printf("Bar\n");
            break;
        default:
            printf("Error\n");
            return 1;
        }
    }
}
