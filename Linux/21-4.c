#include <stdio.h>
#include <stdlib.h>
 
void main(){
    // 16進数
    unsigned char i = 0xf;  //  2進数：00001111
    unsigned char j = 0xff; //  2進数：11111111
		//1ビット左シフト： 2進数：00011110 = 0x1e0
    printf("%x << 1 = %x\n",i,i << 1);  
		//1ビット右シフト： 2進数：00000111 = 0x7
    printf("%x >> 1 = %x\n",i,i >> 1);  
		//OR演算  ： 2進数：11111111 = 0xff
    printf("%x | %x = %x\n",i,j,i | j); 
		//AND演算 ： 2進数：00001111 = 0xf
    printf("%x & %x = %x\n",i,j,i & j); 
		//NOT演算 ： 2進数：11110000 = 0xf0
    printf("~%x = %x\n",i,(unsigned char)~i);   
}
