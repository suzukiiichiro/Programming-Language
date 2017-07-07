#include <stdio.h>

//  iを用いたループ
void main(){
	int num;
	printf("負の値で、ループから抜けます。\n");
	while(1){
		printf("数値を入力：");
		scanf("%d",&num);
		if(num < 0){
			//  ループから抜ける処理
			break;
		}
	}
	printf("終了\n");
}
