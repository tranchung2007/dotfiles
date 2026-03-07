void decrypt(char *msg, int key);
void encrypt(char *msg);

void encrypt(char *msg) {
    while (*msg) {
        *msg =*msg ^ 36;
        msg++;
    }
}

void decrypt(char *msg, int key) {
    while (*msg) {
        *msg ^= key;
        msg++;
    }
}
