#include <stdio.h>
#include <string.h>
 
//  学生のデータを入れる構造体
struct student{
    int id; //  学生番号
    char name[256]; //  名前
    int age;        //  年齢
};
 
//  構造体の名前をtypedefで定義
typedef struct student student_data;
 
void main(){
    int i;
    student_data data[] = {
        { 1,"山田太郎",18 },
        { 2,"佐藤良子",19 },
        { 3,"太田隆",18 },
        { 4,"中田優子",18 }
    };
    //  データの内訳を表示
    for(i = 0; i < 4; i++){
        printf("学生番号:%d 名前:%s 年齢:%d\n",data[i].id,data[i].name,data[i].age);
    }
}
