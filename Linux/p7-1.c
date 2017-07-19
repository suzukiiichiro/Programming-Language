#include <stdio.h>

#define max 100
//void arraypass(int aB[0]){ // どちらでもよい
void arraypass(int *aB){
  for(int i=0;i<max;i++){
    printf("aB[%d]=%d\n",i,aB[i]);
  }
}
int main(void){
  int aB[max];
  for(int i=0;i<max;i++){
    aB[i]=i;
  }
  arraypass(aB);
  return 0;
}
