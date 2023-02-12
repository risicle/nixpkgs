/* an example that should be protected by FORTIFY_SOURCE=3 but
 * not FORTIFY_SOURCE=2 */
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]) {
    char* buffer = malloc(atoi(argv[1]));
    strcpy(buffer, argv[2]);
    puts(buffer);
    return 0;
}
