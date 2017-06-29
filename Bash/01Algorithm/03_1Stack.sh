#!/bin/bash

#####
# stack (push/pop)
#
# スタックはデータ構造の一つです。
# スタックの仕組みは、ものを縦に積み上げる事を考えるとイメージしやすいです。
# 積み上げられた山からものを取り出す場合、上から順番に取り出す事になります。
# スタックにデータを追加する場合、データは一番最後に追加されます。
# スタックにデータを追加する操作をpushと呼びます。
# スタックからデータを取り出す場合、最も新しく追加されたデータから取り出されます。
# スタックからデータを取り出す操作をpopと呼びます。
# このような、後から入れたものを先に出す「後入れ先出し」の仕組みを
# 「Last In First Out 」を略してLIFOと呼びます。
# 
#####
##
#
function display(){
  for((n=0;n<nElems;n++));do
    echo "$n" "${array[n]}";
  done
  echo "------";
}
##
#
function insert(){
  array[nElems++]="$1";
}
##
#
function setArray(){
  nElems=0;
  for((i=0;i<$1;i++));do
    insert $(echo "$RANDOM");
  done
}
##
#
function stackPeek(){
  echo "$1 : $nElems:"${array[nElems]}"";
}
##
#
function stackPush(){
  array[nElems++]="$RANDOM";
  stackPeek "push";
}
##
#
function stackPop(){
  (($nElems!=0))&&{
    ((nElems--));
    stackPeek "pop";
  }||{
    echo "Stack is empty";
  }
}
##
#
function stack(){
  display;
  stackPop;
  stackPush;
  stackPush;
  display;
  stackPop;
  stackPop;
  stackPop;
  stackPop;
  display;
  stackPop;
  stackPop;
  stackPop;
  display; 
  stackPop;
  stackPop;
  stackPop;
  display; 
  stackPop;
  stackPop;# Empty
}
##
#
function execStack(){
 setArray "$1";
 stack;
}
##
#
execStack 10;
exit;
