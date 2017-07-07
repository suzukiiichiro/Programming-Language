#include <stdio.h>
 
void show(int,int,int);
 
void main(){
    int a = 100;    //  整数型変数a
    int b = 200;    //  整数型変数b
    int *p = NULL;  //  整数型のポインタ変数p
    p = &a; //  pにaのアドレスを代入
    show(a,b,*p);
    *p = 300;   //  *pに値を代入
    show(a,b,*p);
    p = &b; 		//  pにbのアドレスを代入
    show(a,b,*p);
    *p = 400;   //  *pに値を代入
    show(a,b,*p);
}
/**
a = 100 b = 200 *p = 100 // p=&a
a = 300 b = 200 *p = 300 // *pに300を入れるとaの値も300に変化する
a = 300 b = 200 *p = 200 // p=&b
a = 300 b = 400 *p = 400 // *pに400をいれるとbの値も400に変化する

 p=&a;	pに、aのアドレスを代入	*pはaと同じものになる	100	200	100
*p=300;	*pに300を代入	*pはaに等しいので、aが変わる		300	200	300
 p=&b;	pに、bのアドレスを代入	*pはbと同じものになる	300	200	200
*p=400;	*pに400を代入	*pはbに等しいので、bが変わる		300	400	400

*/ 
void show(int n1,int n2,int n3){
    printf("a = %d b = %d *p = %d\n",n1,n2,n3);
}
