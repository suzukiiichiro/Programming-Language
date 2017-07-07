#include <stdio.h>
#include "calc.h"
#include "showResult.h"

// $ gcc 07-3.c calc.c showResult.c
// $ ./a.out
void main(){
	int a = 2,b = 3;
	printf("%d + %d = ",a,b);
	add(a,b);
	showAnswer();
	printf("%d - %d = ",a,b);
	sub(a,b);
	showAnswer();
}
