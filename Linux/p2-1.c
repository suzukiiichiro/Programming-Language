#include <stdio.h>

int main(void){
  int hoge=5;
  void *p;
  p=&hoge;
  printf("double value : %d\n",*(int *)p);
  return 0;
} 
