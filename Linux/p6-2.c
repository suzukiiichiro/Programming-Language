#include <stdio.h>

#define max 100

int main(void){
  int aB[max];
  for(int i=0;i<max;i++){
    aB[i]=i;
  }
  for(int *p=&aB[0];p!=&aB[max];p++){
    printf("*p=%d\n",*p);
  }
  return 0;
}
