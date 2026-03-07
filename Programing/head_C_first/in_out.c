#include <stdio.h>

int main(int argc, char **argv)
{
    char buf[256];
    FILE *f = fopen("./string.c", "r");
    if (f != NULL) {
        // while (fgets(buf, sizeof(buf), f)) {
        while (fscanf(f, "%255s[^\n]", buf) == 1) {
            printf("%s", buf);
        }
        fclose(f);
    }
    else {
        fprintf(stderr, "Can not open file!\n");
    }
    return 0;
}
