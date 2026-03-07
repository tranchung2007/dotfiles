#include <stdio.h>

void foo() {
    printf("Foo\n");
}

void buzz()

void bar() {
    printf("Bar\n");
}

typedef void (*func)(void);

func function[] = {
    foo,
    bar,
    foo,
    bar,
};

int main(void)
{
    size_t n = sizeof(function) / sizeof(function[0]);
    for (size_t i = 0; i < n; ++i) {
        function[i]();
    }
    return 0;
}
