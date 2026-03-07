/*
 * stb header file to implement dynamic array in C
 * reference to Tosding dynamic array aproach
 * This code is release under the MIT Licence
 */

#include <stdlib.h>
#include <string.h>

#define da_reserve(da, expected_capacity)\
    do {\
        if (expected_capacity > (da)->capacity) {\
            if ((da)->capacity == 0) {\
                (da)->capacity = 256;\
            }\
            while ((expected_capacity) > (da)->capacity) {\
                (da)->capacity *= 2;\
            }\
            (da)->items = realloc((da)->items, (da)->capacity * sizeof(*(da)->items));\
        }\
    } while (0)

#define da_append(da, item)\
    do {\
        da_reserve(da, (da)->count + 1);\
        (da)->items[(da)->count++] = (item);\
    } while (0)

#define da_append_many(da, new_item, item_count)\
    do {\
        da_reserve((da), (da)->count + (item_count));\
        memcpy((da)->items + (da)->count, (new_item), (item_count)*sizeof(*(da)->items));\
        (da)->count += (item_count);\
    } while (0)
