/*
 * Program to evaluate face values.
 * Released under the Vegas Public License.
 * (c)2014 The College Blackjack Team.
 */

// #include <stdio.h>
// #include <stdlib.h>

// int main()
// {
//     char card_name[3];
//     puts("Enter the card_name: ");
//     scanf("%2s", card_name);
//     int val = 0;
//     if (card_name[0] == 'K') {
//         val = 10;
//     } else if (card_name[0] == 'Q') {
//         val = 10;
//     } else if (card_name[0] == 'J') {
//         val = 10;
//     } else if (card_name[0] == 'A') {
//         val = 11;
//     } else {
//         val = atoi(card_name);
//     }
//     printf("The card value is: %i\n", val);
//     return 0;
// }

// #include <stdio.h>
// #include <stdlib.h>

// int main()
// {
//     int card = 1;
//     if (card > 1)
//         card = card - 1;
//     if (card < 7)
//         puts("Small card");
//     else {
//         puts("Ace!");
//     }
//     return 0;
// }

// #include <stdio.h>

// int main()
// {
//     char *cards = "JQK";
//     char a_card = cards[2];
//     cards[2] = cards[1];
//     cards[1] = cards[0];
//     cards[0] = cards[2];
//     cards[2] = cards[1];
//     cards[1] = a_card;
//     puts(cards);
//     return 0;
// }

// #include <stdio.h>

// int main()
// {
//     char arraystring[][40] = {
//         "Hello World!",
//         "Haui!",
//     };
//     int n = sizeof(arraystring) / sizeof(arraystring[0]);
//     for (int i =0; i < n; ++i) {
//         printf("%s\n", arraystring[i]);
//     }
// }

#include <stdio.h>
#include <limits.h>
#include <float.h>

int main()
{
    printf("The value of INT_MAX is %i\n", INT_MAX);
    printf("The value of INT_MIN is %i\n", INT_MIN);
    printf("An int takes %z bytes\n", sizeof(int));
    printf("The value of FLT_MAX is %f\n", FLT_MAX);
    printf("The value of FLT_MIN is %.50f\n", FLT_MIN);
    printf("A float takes %zu bytes\n", sizeof(float));
    return 0;
}
