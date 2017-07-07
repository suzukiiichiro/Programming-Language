#include <stdio.h>

void main(){
	double d1,d2,d3;
	double a = 1.2,b = 3.4,c = 2.7;
	//   同じ計算が3回
	d1 = (a + b) / 2.0;
	d2 = (4.1 + 5.7) / 2.0;
	d3 = (c + 2.8) / 2.0;
	printf("d1 = %f,d2 = %f,d3 = %f\n",d1,d2,d3);
}
