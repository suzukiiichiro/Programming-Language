#include <stdio.h>

int main(void){
  int hoge=5;
  int piyo=10;
  int *p;
  p=&hoge;
  *p=10;
  printf("hoge value : %d\n",hoge);
  return 0;
}
