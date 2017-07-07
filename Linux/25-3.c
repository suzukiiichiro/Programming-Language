#include <stdio.h>
#include <string.h>
 
//  学生のデータを入れる構造体
typedef struct{
    int id;         //  学生番号
    char name[256]; //  名前
    int age;        //  年齢
}student_data;
 
//  構造体のデータを表示する関数
void setData(student_data*,int,char*,int);
void showData(student_data*);
 
void main(){
    student_data data[4];
    int i;
    int id[] = { 1,2,3,4 };
    char name[][256] = { "山田太郎","佐藤良子","太田隆","中田優子" };
    int age[] = { 18,19,18,18 };
    //  データの設定
    for(i = 0; i < 4; i++){
        setData(&data[i],id[i],name[i],age[i]);
    }
    //  データの内訳を表示
    for(i = 0; i < 4; i++){
        showData(&data[i]);
    }
    return;
}
//  データのセット
void setData(student_data* data,int id,char* name,int age){
    data->id = id;               //  idのコピー
    strcpy(data->name,name); //  名前のコピー
    data->age = age;         //  年齢のコピー
}
//  データの表示
void showData(student_data* data){
    printf("学生番号:%d 名前:%s 年齢:%d\n",data->id,data->name,data->age); 
}
