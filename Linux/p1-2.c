#include <stdio.h>

int main(void){
  int hoge=5;
  int piyo=10;
  int *p;

  p=&hoge;
  printf("*p value: %d\n",*p);
  return 0;
}

