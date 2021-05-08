#include <iostream>
#include <fcntl.h>
#include <unistd.h>

using namespace std;

int main(int argc, char *argv[]) {
    const char *filename = argv[1];
    int fd = open(filename, O_CREAT|O_WRONLY, 777);
    char c;
    int zero_counter = 0;
    while (cin.get(c)){
        if (c == 0){
            zero_counter++;
            continue;
        } else {
            lseek(fd, zero_counter, SEEK_CUR);
            write(fd, &c, 1);
            zero_counter = 0;
        }
    }
    fsync(fd);
    return 0;
}
