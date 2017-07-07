#include <stdio.h>
#include <string.h>
 
void main(){
   char s[10];
   int len;
   //   文字列のコピー
   strcpy(s,"ABC");
   printf("s=%s\n",s);
   //   文字列の結合
   strcat(s,"DEF");
   printf("s=%s\n",s);
   //   文字列の長さ
   len = strlen(s);
   printf("文字列の長さ：%d\n",len);
}
