#include <stdio.h>

void swap(int a, int b){
   int tmp;
   tmp=a;
   a=b;
   b=tmp;
}
int main(void){
  int a=5;
  int b=3;
  swap(a,b);
  printf("a: %d b: %d\n", a,b);
  return 0;
}
