#include "da.h"
#include <stdio.h>

typedef struct {
    size_t *items; // type of dynamic array depend on type of this pointer
    size_t count;
    size_t capacity;
} Numbers;

typedef struct {
    const char **items; // type of dynamic array depend on type of this pointer
    size_t count;
    size_t capacity;
} Names;

int main(void)
{
    Numbers xs = {0};
    size_t new_data[] = { 1, 20, 100 };
    da_append_many(&xs, new_data, sizeof(new_data) / sizeof(new_data[0]));
    for (size_t i = 0; i < xs.count; ++i) printf("%d ", xs.items[i]);

    Names person = {0};
    char *name_list[] = {"chung", "tran", "thanh"};
    da_append_many(&person, name_list, sizeof(name_list) / sizeof(name_list[0]));
    for (size_t i = 0; i < person.count; ++i) printf("%s ", person.items[i]);

    return 0;
}
