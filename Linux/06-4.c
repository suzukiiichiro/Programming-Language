#include <stdio.h>

//プロトタイプ宣言
int max(int,int);
void show(int);
void line();

void main(){
	int n1 = 4,n2 = 5;
	line();
	show(n1);
	show(n2);
	printf("二つの数のうち、大きい数は、%dです。\n",max(n1,n2));
	line();
}
//  2つの整数のうち最大値を求める関数
int max(int a,int b) {
	if(a > b){
		return a;
	}
	return b;
}
//  数値を表示する関数
void show(int n) {
	printf("数値：%d\n",n);
	return;
}
void line() {
	printf("*********\n");
}
