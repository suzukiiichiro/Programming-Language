#include <stdio.h>

void main()
{
	int dice;
	//  サイコロの目を入力
	printf("1から6の数値を入力してください:");
	scanf("%d",&dice);
	//  値が、サイコロの目の範囲内かどうかを調べる
	if(1 <= dice && dice <= 6){
		//  さいころの目が、偶数か、奇数かで、処理を分ける。
		if(dice == 2 || dice == 4 || dice == 6){
			printf("丁（チョウ）です。\n");  //  偶数ならば丁（チョウ）
		}else{
			printf("半（ハン）です。\n");   //  奇数ならば半（ハン）
		}
	}else{
		printf("範囲外の数値です。\n");
	}
}
