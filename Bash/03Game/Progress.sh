#! /bin/bash

#######################################
# 進捗を表示するプログレスバー
#  
#######################################
#
#
# percent $1 
# GT      $2
progress(){

  percent=$1;
  GT=$2;  

  column=`expr 71 \* "$percent" / $GT`;
  nspace=`expr 71 - "$column"`;

  #プログレスバーのカーソルを左端に戻すリターンコードと[の文字をbarに代入
  bar='\r['; 

  #位置パラメータの数($#)を１にリセット（カウンタとして流用）
  set dummy ;
  while [ $# -le "$column" ];do
    bar=$bar'=';      # barに=を追加
    set - "$@" dummy; # $#をインクリメント
  done
  bar=$bar'>';        #barの先端に>を追加

  #位置パラメータの数($#)を１にリセット（カウンタとして流用）
  set dummy ;
  while [ $# -le "$nspace" ]; do 
    bar=$bar' ';
    set - "$@" dummy;
  done
  bar=$bar']'$percent/$GT'\c'; # barに]と１行分のプログレスバーを表示

  echo -e "$bar"; 
}

#######################################
# メイン処理
#
set count ;
MAX=100 ; #最大値を100とする
#
for (( i=0; i<$MAX; i++)){
  progress "$#" "$MAX"; set - "$@" count ;
}
echo "";
#
#終了
exit ;
