#include <stdio.h>
//  関数avgのプロトタイプ宣言
double avg(double,double);

void main(){
	double d1,d2,d3;
	double a = 1.2,b = 3.4,c = 2.7;
	//   同じ計算が3回(関数を呼び出して計算）
	d1 = avg(a,b);
	d2 = avg(4.1,5.7);
	d3 = avg(c,2.8);
	printf("d1 = %f\nd2 = %f\nd3 = %f\n",d1,d2,d3);
}

//  平均値を求める関数
double avg(double l,double m){
	//  引数l,mの平均値を求め、rに代入する。
	double r = (l + m) / 2.0;
	return r;
}
