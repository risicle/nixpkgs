/* an example that should be protected by FORTIFY_SOURCE=2 */
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]) {
    char buffer[8];
    strcpy(buffer, argv[1]);
    puts(buffer);
    return 0;
}
