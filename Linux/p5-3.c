#include <stdio.h>

int main(void){
  int aB[5];
  for(int i=0;i<5;i++){
    aB[i]=i;
  }
  //int *p=aB; // どちらでもいい
  int *p=&aB[0];
  for(int i=0;i<5;i++){
    //printf("*p=%d\n", *(p+i)); //どちらでもいい
    printf("aB[%d]=%d\n",i, aB[i]);
  }
  return 0;
}
