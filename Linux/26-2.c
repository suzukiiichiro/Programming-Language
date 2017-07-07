#include <stdio.h>
#include <stdlib.h>

#define SIZE    256

void main() {
	FILE *file;       // ファイルポインタ（読み込み用）
	char line[SIZE];  //  読み込む行
	line[0] = '\0';   //  初期化（空文字列）
	file = fopen("sample.txt", "r");  // ファイルを読み込み用にオープン(開く)
	if (file == NULL) {               // オープンに失敗した場合
		printf("ファイルが開けません。\n"); // エラーメッセージを出して
		exit(1);                        // 異常終了
	}
	//  ファイルのデータ読み込む
	while ( fgets(line, SIZE, file) != NULL ) {
		printf("%s", line);
	}
	fclose(file);     // ファイルをクローズ(閉じる)
}
