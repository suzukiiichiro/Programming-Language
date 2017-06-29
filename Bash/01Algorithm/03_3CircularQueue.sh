#!/bin/bash

#########
# Circular Queue
# 映画館の待ち行列なら、先頭の一人が列を去ったら、列全体が前に進みます。
# キューでも、削除のたびに全ての項目を移動する事は出来ますが、しかしその時間が無駄です。
# むしろ項目はそのままにしておいて、キューの前端や後端が動いた方が簡単なのです。
# しかしその場合の問題は、キューの後端がすぐに配列の終端に達してしまいます。
# まだ満杯ではないのに新たなデータを挿入できないというこの問題を解決するために、
# キューのfrontとrear矢印は配列の先頭へラップアラウンド（最初に戻る）します。
# その結果として円環キューというものができあがります。リングバッファとも呼ばれます。
# 
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
function CircularQDisplay(){
  for((i=0;i<maxSize;i++));do
      echo "$i" "${queue[i]}";
  done
  echo "------";
}
##
#
function CircularQDequeue(){
  ((front++));
  ((front==maxSize))&&{ front=0; }
}
##
#
function CircularQEnqueue(){
  (( rear==(maxSize-1) ))&&{ rear=-1; }
  queue[++rear]=$1;
}
##
#
function CircularQPeek(){
  echo "peek :front :$front  rear : $rear  peek : $front ${queue[front]} ";
}
##
#
function execCircularQ(){
  rear=-1; #後ろ端（enqueueされるほう）
  front=0; #前端（peek/dequeueされるほう)

  maxSize=5 #キューの項目数

  CircularQEnqueue 10;
  CircularQEnqueue 20;
  CircularQEnqueue 30;
  CircularQEnqueue 40;
  echo "データを4つenqueue";
  CircularQPeek;
  CircularQDisplay;
#exit;
  #----
  CircularQDequeue;
  CircularQDequeue;
  echo "データを2つdequeue";
  CircularQPeek;
  CircularQDisplay;
#exit;
  #----
  CircularQEnqueue 50;
  echo "データを1つenqueue";
  CircularQPeek;
  CircularQDisplay;
#exit;
  #----
  # CircularQ
  CircularQEnqueue 60;
  CircularQEnqueue 70;
  echo "データを2つenqueue";
  CircularQPeek;
  CircularQDisplay;
#exit;
  #---
  CircularQDequeue;
  CircularQDequeue;
  CircularQDequeue;
  echo "データを3つdequeue";
  CircularQPeek;
  CircularQDisplay;
}
##
#
execCircularQ;
exit;

