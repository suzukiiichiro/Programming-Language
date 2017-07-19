#include <stdio.h>

int main(void){
  int hoge;
  int *p;
  p=&hoge;
  printf("hoge addr: %p\n",&hoge);
  printf("p addr:%p\n", p);
  p++;
  printf("p++ addr:%p\n", p);

  printf("p+3 addr:%p\n",p+3);
  return 0;
}
