#include <stdio.h>

#define SIZE 1000000
int ar[SIZE];

void main(){
  for(int i=0;i<SIZE;i++){
    ar[i]=i;
  }
  int *p;
  p=&ar[0];
  for(int i=0;i<SIZE;i++){
    printf("ar[%d]:%d\n",i,*(p+i));
   // printf("ar[%d]:%d\n",i,ar[i]);
  }
}
/**
real    0m12.456s
user    0m0.390s
sys     0m0.793s
*/
