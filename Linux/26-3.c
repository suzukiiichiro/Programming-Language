#include <stdio.h>
#include <stdlib.h>

void main() {
	FILE *file;           // ファイルポインタ（読み込み用）
	int c;                //  読み込む文字のコード
	file = fopen("sample.txt", "r"); // ファイルを読み込み用にオープン(開く)
	if (file == NULL) {   // オープンに失敗した場合
		printf("ファイルが開けません。¥n");  // エラーメッセージを出して
		exit(1);            // 異常終了
	}
	//    ファイルのデータ読み込む
	while ( (c=fgetc(file)) != EOF){
		printf("%c",(char)c);
	}
	fclose(file);          // ファイルをクローズ(閉じる)
}
