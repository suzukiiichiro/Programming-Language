#!/bin/bash

#################################################
# パラメータで渡されたファイル名をutf8に変換する
# nkf -wLu 
#
# cp wLu.sh /usr/bin/wLu 
# といったぐあいにこのシェルスクリプトをコマンド登録する事によって、
# 日常の作業の中でUTF-8に変換したいファイルを
# $ wLu sjisfille
# と実行すると sjisfileは utf-8に変換されます。
#################################################
#
if [ $# -ne 1 ]; then
  echo ""
  exit ;
fi
filename="$1" ;
#
function wLu(){
  if [ -f "$filename" ]; then
    cat "$filename" | nkf -wLu > "$filename".u ;
    mv "$filename".u "$filename" ;
  fi
}
#
if ! which nkf >/dev/null 2>&1; then
  echo "nkf がありません" ;
  echo "nkf をインストールして下さい" ; 
  exit ;
fi
#
if [ -z "$filename" ] ; then
  echo "第一引数にファイル名を指定して下さい"
  echo "実行例： ./wLu.sh sample.sh " ;  
  exit ;
fi
# 実行
wLu ;
# 終了
exit ;
