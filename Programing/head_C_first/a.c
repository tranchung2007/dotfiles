#include <stdio.h>

void Foo(); // function Declaration
void Bar();

int main()
{
    Foo();
    return 0;
}

void Foo(void) { // function Definition
    printf("Foo\n");
    Bar();
}

void Bar(void) {
    printf("Bar\n");
    // Foo();
}
