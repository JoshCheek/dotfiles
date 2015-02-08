// from root, I compiled it like this:
// $ clang -Ofast -o bin/chomp source/chomp.c
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char const *argv[]) {
  int current_char = -1;
  int next_char    = getc(stdin);

  if(next_char == EOF) exit(0);

  while(1) {
    current_char = next_char;
    next_char    = getc(stdin);
    if(next_char == EOF) break;
    putc(current_char, stdout);
  }

  if(current_char != '\n')
    putc(current_char, stdout);
}
