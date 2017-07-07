#include <stdio.h>

//  データを入れる構造体
typedef struct{
	int a;
	double d;
}num_data;

//  二種類の値設定関数
void dealData1(num_data data);      //  値渡し
void dealData2(num_data* pData);    //  ポインタ渡し

void main(){
	num_data n1 = { 1, 1.2f },n2 = { 1, 1.2f };
	printf("n1のアドレス:0x%x \nn2のアドレス:0x%x\n",&n1,&n2);
	dealData1(n1);
	dealData2(&n2);
	printf("n1.a = %d n2.d = %f\n",n1.a,n1.d);
	printf("n2.a = %d n2.d = %f\n",n2.a,n2.d);
}

void dealData1(num_data data)
{
	printf("a=%d f=%f\n",data.a,data.d);
	printf("dealData1にあたってきたデータのアドレス:0x%x\n",&data);
	//  値の変更
	data.a = 2;
	data.d = 2.4;
}
void dealData2(num_data* pData)
{
	printf("a=%d f=%f\n",pData->a,pData->d);
	printf("dealData2にあたってきたデータのアドレス:0x%x\n",pData);
	//  値の変更
	pData->a = 2;
	pData->d = 2.4;
}
