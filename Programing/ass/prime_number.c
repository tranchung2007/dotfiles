#include <stdio.h>

int main(void)
{
    unsigned guess = 5;
    unsigned factor;
    unsigned limit = 100;
    while (guess <= limit) {
        factor = 3;
        while (factor * factor < guess && guess % factor != 0) {
            factor += 2;
        }
        if (guess % factor != 0) {
            printf("%d\n", guess);
        }
        guess += 2;
    }
}
