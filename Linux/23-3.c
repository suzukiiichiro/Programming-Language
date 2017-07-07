#include <stdio.h>
#include <stdlib.h>

#define SIZE    3

void main(){
	//  配列の生成
	int* p1 = (int*)malloc(sizeof(int)*SIZE);
	double* p2 = (double*)malloc(sizeof(double)*SIZE);
	//  値の代入
	for(int i = 0; i < SIZE; i++){
		//p1[i] = i;
		*(p1+i) = i;
		//p2[i] = i / 10.0;
		*(p2+i) = i / 10.0;
	}
	//  結果の出力
	for(int i = 0; i < SIZE; i++){
		//printf("p1[%d]=%d  p2[%d]=%f\n",i,p1[i],i,p2[i]);
		printf("*(p1+%d)=%d  *(p2+%d)=%f\n",i,*(p1+i),i,*(p2+i));
	}
	//  メモリの開放
	free(p1);
	free(p2);
}
