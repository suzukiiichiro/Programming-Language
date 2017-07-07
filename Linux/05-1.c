#include <stdio.h>

void main(){
	double one,two,three;           //  変数の宣言
	double sum,avg; //  合計値、平均値を入れる変数
	one = 1.2,two = 3.7,three = 4.1;    //  変数の代入
	printf("%f %f %f\n",one,two,three);
	sum = one + two + three;    //  合計値の計算
	avg = sum / 3.0;            //  平均値の計算
	printf("合計値：%f\n",sum);
	printf("平均値：%f\n",avg);
}
