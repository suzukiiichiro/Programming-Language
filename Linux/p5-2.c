#include <stdio.h>

int main(void){
  int aB[5];
  for(int i=0;i<5;i++){
    aB[i]=i;
  }
  for(int *p=&aB[0];p!=&aB[5];p++){
    printf("*p=%d\n",*p);
  }
  return 0;
}
