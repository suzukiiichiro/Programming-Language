#include <stdio.h>

int main(void){
  int aB[5];
  for(int i=0;i<5;i++){
    aB[i]=i;
    printf("aB[%d]=%d\n",i,aB[i]);
    printf("aB[%d]=%p\n",i,&aB[i]);
  }
  return 0;
}
