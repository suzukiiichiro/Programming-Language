#include <stdio.h>

#define max 100

int main(void){
  int aB[max];
  for(int i=0;i<max;i++){
    aB[i]=i;
  }
  for(int i=0;i<max;i++){
    printf("aB[%d]=%d\n",i, aB[i]);
  }

  return 0;
}
