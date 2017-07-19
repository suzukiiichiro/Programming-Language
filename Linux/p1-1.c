#include <stdio.h>

int main(void){
  int hoge=5;
  int piyo=10;
  int *p;

  printf("hoge addr: %p\n",&hoge);
  printf("piyo addr: %p\n",&piyo);
  printf("*p   addr: %p\n",&p);
  return 0;
}
