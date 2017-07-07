#include <stdio.h>

void main(){
	int num;
	printf("1-3の値を入力してください：");
	//  キーボードから整数を入力
	scanf("%d",&num);
	//  入力した値が、正の数かどうかを調べる
	switch(num){
		case 1:
			printf("one\n");    //  numが1だった場合の処理
			break;
		case 2:
			printf("two\n");    //  numが2だった場合の処理 
			break;
		case 3:
			printf("three\n");  //  numが3だった場合の処理 
			break;
		default:
			printf("不適切な値です。\n"); //  それ以外の値が入力された場合の処理
			break;
	}
}
