#include <stdio.h>
#include "en_decrypt.h"

int main(void)
{
    char msg[80] = "This is the string";

    encrypt(msg);
    // printf("%s\n", msg);

    decrypt(msg, 36);
    printf("%s\n", msg);

}
