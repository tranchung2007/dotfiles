// Create a window using Raylib

#include <raylib.h>

int main(void)
{
    InitWindow(800, 600, "raylib");
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RED);
        DrawCircle(300, 200, 100, WHITE);
        EndDrawing();
    }
}
