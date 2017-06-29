#!/bin/bash

#
##################
# クイックソート
##################
#
# クイックソートは数列を整列するアルゴリズムです。
# 他のアルゴリズムに比べ、数の比較と交換回数が少ないのが特徴で、
# 多くのケースで高速にソートが出来ます。
#
# 初回の操作の対象は数列の全ての数とします。
# 
# 3   5   8   1   2   9   4   7   6 
#
# ソートの基準となる数を１つ選びます。この数の事をpivotと呼びます。
# pivotは通常、１つの数をランダムに選択します。
# 今回は便宜上、常に一番右の数をpivotとして選ぶ事にします。
# 
# わかりやすいようにpivotにマーカーをおきます。
# 3   5   8   1   2   9   4   7  (6)
#                                 P
#
# つづいて、一番左の数に左マーカーL、右の数に右マーカーRを設置します。 
#(3)  5   8   1   2   9   4  (7)  6 
# L                           R   P
#
# クイックソートはこれらのマーカーを使い 一連の操作を再帰的に繰り返すアルゴリズムです。
# それでは、左マーカーを右に動かしていきます。
# 3  (5)  8   1   2   9   4   7   6 
#     L                       R   P
#
# 【ルール1】左マーカーがpivotの数以上の場合、動きを止めます。
# 今回は8>=6なので止まりました。
#
# ◎ 1.IF L>=P : 止まる
# 3   5  (8)  1   2   9   4   7  (6)
#         L                   R   P
#
# つづいて、右マーカーを左に動かしていきます。
# 【ルール2】右マーカーはpivotより小さい数にたどり着いた場合動きを止めます。
# 今回は4<6なので止まりました。
#
#   1.IF L>=P : 止まる
# ◎ 2.IF R<P  : 止まる
# 3   5   8   1   2   9  (4)  7  (6)
#         L               R       P
#
# 【ルール3】左右のマーカーが止まったとき、マーカーの数を入れ替えます。
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
# ◎ 3.IF L>=P && R<P : L<->R
# 3   5  (4)  1   2   9  (8)  7   6 
#         L               R       P
# 
# このように、左マーカーの役割はpivot以上の数を見つける事、
# 右マーカーの役割はpivotより小さな数を見つける事です。
# 数を入れ替える事で、数列の左側にpivotより小さな数、
# 右側にpivot以上の数を集める事が出来ます。
#
# 入れ替えた後は、再び左マーカーを右に動かしていきます。
# 3   5   4  (1)  2   9   8   7   6 
#             L           R       P
#
# 3   5   4   1  (2)  9   8   7   6 
#                 L       R       P
#
# 9>=6なので止まりました。
# ◎ 1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
# 3   5   4   1   2  (9)  8   7  (6)
#                     L   R       P
#
# つづいて、右マーカーを左に動かします。
# 3   5   4   1   2  (9)  8   7   6 
#                     LR          P
#
# 【ルール4】右マーカーが、左マーカーにぶつかった場合動きを止めます。
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
# ◎ 4.IF L|<R  : 止まる
# 3   5   4   1   2  (9)  8   7   6 
#                     LR          P
#
#  【ルール5】その後、LRとpivotの数を入れ替え、
# 3   5   4   1   2  (6)  8   7  (9)
#                     LR          P
#
#  【ルール5続き】その後、LRを済みとします。
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
# ◎ 5.IF L|<R : 止まる : LR<->P : LR=済み
#                     済          
# 3   5   4   1   2  (6)  8   7   9
# 
# これで初回の操作が完了しました。
# 一連の操作によって数列をpivotより左の「pivotより小さな数」と、
# pivotより右の「pivotより大きな数」に分ける事が出来ました。
# ２つに分かれた各数列に対して、一連の操作を再帰的に行っていきます。
#
# 次は、分かれた左側の数列を操作の対象とします。
#                     済          
# 3   5   4   1   2   6   8   7   9 
# ←               →
#
# ３つのマーカーを設置します。
#                     済          
# 3   5   4   1   2   6   8   7   9 
# L           R   P  
#
#
# 先程と同様の操作を行っていきます。
# すでにLはL>=P なので止まります。
# ◎ 1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<$ : 止まる : LR<->P : LR=済み
#                     済          
#(3)  5   4   1  (2)  6   8   7   9 
# L           R   P  
#
# すでにRもR<P なので止まります。
#   1.IF L>=P : 止まる
# ◎ 2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#                     済          
# 3   5   4  (1) (2)  6   8   7   9 
# L           R   P 
# 
# LとRを入れ替えます
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
# ◎ 3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#                     済          
#(1)  5   4  (3)  2   6   8   7   9 
# L           R   P  
# 
# Lを右にずらします。
# LはL>=P なので止まります。
# ◎ 1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#                     済          
# 1  (5)  4   3   2   6   8   7   9 
#     L       R   P  
# 
# Rを左にずらします。
#                     済          
# 1   5  (4)  3   2   6   8   7   9 
#     L   R       P  
# 
# さらにRをひだりにずらすとLとRがぶつかったので止まります。
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
# ◎ 4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#                     済          
# 1  (5)  4   3   2   6   8   7   9 
#     LR          P  

# LRとPを交換して
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
# ◎ 5.IF L|<R : 止まる : LR<->P : LR=済み
#                     済          
# 1  (2)  4   3  (5)  6   8   7   9 
#     LR          P  
#
# LRを済みとします。
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
# ◎ 5.IF L|<R : 止まる : LR<->P : LR=済み
#     済              済          
# 1  (2)  4   3   5   6   8   7   9 
#     
#
# さらに再帰的に一連の操作を繰り返します。
#     済              済          
# 1   2   4   3   5   6   8   7   9 
# ↑    
#
# L、R、Pivotを設置します。
#
#     済              済          
# 1   2   4   3   5   6   8   7   9 
#LRP    
#
# 【ルール6】対象の数列の数が１つだった場合、ソート済みとします。
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
# ◎ 6.L|R|P : LRP=済み
# 済  済              済          
# 1   2   4   3   5   6   8   7   9 
#
# つづいて２回目の操作で分かれた右側の数列を操作の対象とします。
# 済  済              済          
# 1   2   4   3   5   6   8   7   9 
#         ←       → 
#
# ３つのマーカーを設置します。
# 済  済              済          
# 1   2   4   3   5   6   8   7   9 
#         L   R   P
#
# 左マーカーを右に動かしていきます。
# 左マーカーは右マーカーとぶつかっても止まりません。その点は右マーカーの動きとは異なります。
# 済  済              済          
# 1   2   4  (3)  5   6   8   7   9 
#             LR  P
#
# 【ルール7】左マーカーはpivotにたどり着いたら止まります。
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
# ◎ 7.IF L>|P : 止まる
# 済  済              済          
# 1   2   4   3  (5)  6   8   7   9 
#             R   LP
#
# 次に、右マーカーを動かしますが、左マーカーに追い越されている場合には動かさずに終了し
# 済  済              済          
# 1   2   4  (3)  5   6   8   7   9 
#             R   LP
#
# 【ルール8】左マーカーが、操作対象の右端に達している場合pivotをソート済みとします。
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
# ◎ 8.IF L>|P && LP=済み
# 済  済          済  済          
# 1   2   4   3  (5)  6   8   7   9 
#                 LP
# 
# 同様の操作を繰り返します。
# 済  済          済  済          
# 1   2   4   3   5   6   8   7   9 
#         ←   →             
#
# 済  済          済  済          
# 1   2   4   3   5   6   8   7   9 
#         LR  P             
#
# ◎ 1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済          済  済          
# 1   2  (4)  3   5   6   8   7   9 
#         LR  P
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
# ◎ 4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済          済  済          
# 1   2  (4)  3   5   6   8   7   9 
#         LR  P
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
# ◎ 5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済  済      済  済          
# 1   2  (3)  4   5   6   8   7   9 
#
# 済  済  済      済  済          
# 1   2   3   4   5   6   8   7   9 
#            ←→         
#
# 済  済  済      済  済          
# 1   2   3  (4)  5   6   8   7   9 
#            LRP
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
# ◎ 6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済  済  済  済  済          
# 1   2   3  (4)  5   6   8   7   9 
#
# 済  済  済  済  済  済          
# 1   2   3   4   5   6   8   7   9 
#                         ←       →
#
# 済  済  済  済  済  済          
# 1   2   3   4   5   6   8   7   9 
#                         L   R   P
#
# 済  済  済  済  済  済          
# 1   2   3   4   5   6   8   7   9 
#                             LR  P
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
# ◎ 7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済  済  済  済  済          
# 1   2   3   4   5   6   8   7   9 
#                             R   LP
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
# ◎ 8.IF L>|P && LP=済み
# 済  済  済  済  済  済          済
# 1   2   3   4   5   6   8   7   9 
#                             
#
# 済  済  済  済  済  済          済
# 1   2   3   4   5   6   8   7   9 
#                         ←   →
#
# 済  済  済  済  済  済          済
# 1   2   3   4   5   6   8   7   9 
#                        LR   P
#
# ◎  1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済  済  済  済  済          済
# 1   2   3   4   5   6  (8)  7   9 
#                        LR   P
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
# ◎ 4.IF L|<R : 止まる
#   5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済  済  済  済  済          済
# 1   2   3   4   5   6  (8)  7   9 
#                         LR   P
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
# ◎ 5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済  済  済  済  済  済      済
# 1   2   3   4   5   6  (7)  8   9 
#                         LR   P
#
# 済  済  済  済  済  済  済      済
# 1   2   3   4   5   6   7   8   9 
#                            ←→                        
#
# 済  済  済  済  済  済  済      済
# 1   2   3   4   5   6   7  (8)  9 
#                            LRP 
#
#   1.IF L>=P : 止まる
#   2.IF R<P  : 止まる
#   3.IF L>=P && R<P : L<->R
#   4.IF L|<R : 止まる
# ◎ 5.IF L|<R : 止まる : LR<->P : LR=済み
#   6.L|R|P : LRP=済み
#   7.IF L>|P : 止まる
#   8.IF L>|P && LP=済み
# 済  済  済  済  済  済  済  済  済
# 1   2   3   4   5   6   7  (8)  9 
#                            
# ########################################################
#<>quickSort
#クイックソート
#https://www.youtube.com/watch?v=aQiWF4E8flQ
#　平均計算時間が O(n Log n)
#　安定ソートではない
#　最大計算時間が O(n^2)
#
#データ数が 50 以下なら挿入ソート (Insertion Sort)
#データ数が 5 万以下ならマージソート (Merge Sort)
#データ数がそれより多いならクイックソート (Quick Sort)
#
# 1. 一般的なクイックソート
# 2. ３つのメジアンによる分割と、
#    小さな配列の場合はマニュアルソートを取り入れたクイックソート
# 3.
#
#
##############
# 共通ブロック
##############
display(){
    for((i=0; i<"$nElems"; i++));do
        echo "$i" "${array["$i"]}";
    done
    echo "------" ;
}
insert(){
    array[((nElems++))]=$1
}
setArray(){
    nElems=0;
    for((i=0; i<"$1"; i++));do
        insert `echo "$RANDOM"` ;
    done
}


##
#
########################################
# 3. 【完成版】小さな分割の場合に挿入ソートを行うクイックソート
# クイックソートのような強力なアルゴリズムが、再帰呼び出しの行き着く果てに、わ
# ずか２項目か３項目の小さな配列にも適用されるのは、妙な感じがします。最後の段
# 階、いわゆる小さな分割の場合に挿入ソートを行うクイックソート完成版。 
# 分割によってできる部分配列がある程度大きい間はクイックソートをして、それ以降
# の小さな部分配列はそのまま放置します。そうすると、配列全体としては、ほとんど
# ソートされた状態になります。その配列全体に対して、今度は挿入ソートを適用しま
# す。挿入ソートはほとんどソートされた状態の配列に対しては高速です。と、何人か
# の専門家は言っていますが、実は挿入ソートは、大きな配列を１つソートするより、
# 小さなソートをたくさんするほうが向いているのです。
#
pertisionIt3(){
    #最初の成分の右
    local leftPtr=$1  ;
    #分割値の左
    local rightPtr=$(($2-1)) ;
    local pivot=$3
    while :; do
        #より大きい項目を見つける
        while (( "${array[++leftPtr]}" < "$pivot" )); do
           : 
        done
        #より小さい項目を見つける
        while (( "${array[--rightPtr]}" > "$pivot" )); do
           :
        done
        #ポインタが交差したら
        if [ "$leftPtr" -ge "$rightPtr" ]; then
            #分割は終了
            break ;
        else
            # leftPtr rightPtr
            #交差していないので成分を入れ替える
            local tmp="${array[leftPtr]}" ;
            array[leftPtr]="${array[rightPtr]}" ;
            array[rightPtr]="$tmp" ;
        fi
    done
    #leftPtr right-1
    #分割値をリストア
    local tmp="${array[leftPtr]}" ;
    array[leftPtr]="${array[right-1]}" ;
    array[right-1]="$tmp" ;
    #分割値の位置を返す
    pertision="$leftPtr" ;
}
medianOf3_3(){
    local left=$1 ;
    local right=$2 ;
    local center="$(( (left+right) / 2 ))" ;

    if [ "${array[left]}" -gt "${array[center]}" ]; then
        # left / centerを正順化
        local tmp="${array[left]}" ;
        array[left]="${array[center]}" ;
        array[center]="$tmp" ;
    fi
    if [ "${array[left]}" -gt "${array[right]}" ]; then
        # left / rightを正順化
        local tmp="${array[left]}" ;
        array[left]="${array[right]}";
        array[right]="$tmp" ;
    fi
    if [ "${array[center]}" -gt "${array[right]}" ]; then
        # center rightを正順化
        local tmp="${array[center]}" ;
        array[center]="${array[right]}" ;
        array[right]="$tmp" ;
    fi
    # 分割値をrightに
    local tmp="${array[center]}" ;
    array[center]="${array[right-1]}" ;
    array[right-1]="$tmp" ;
    #メジアンの値を返す
    median="${array[right-1]}" ;
}
#挿入ソート
function iSort3(){
    for(( out=left+1; out<=right; out++ ));do
        tmp="${array[out]}" ;
        in="$out" ;
        while(( in>left && array[in-1]>=tmp )); do
            array[in]="${array[in-1]}" ;
            ((--in));
        done
        array[in]="$tmp"
    done 
}
function quickSort3(){
    local left="$1" ;
    local right="$2" ;
    local size=$((right-left+1)) ;
    #小さければ挿入ソート
    if [ "$size" -lt 10 ]; then
        iSort3 "$left" "$right" ;
    else
        medianOf3_3 "$left" "$right" ;
        #範囲を分割する 戻り値は $pertision 
        pertisionIt3 "$left" "$right" "$median";
        #左側をソート
        quickSort3 "$left" "$((pertision-1))"  ;
        #右側をソート
        quickSort3 "$((pertision+1))" "$right" ; 
    fi
}
#
########################################
# 2. ３つのメジアンによる分割と
# 要素数が３よりも小さな配列の場合はマニュアルソートを取り入れたクイックソート
#
# クイックソートの分割値の選び方は、これまでにいろんな方法が提案されています。
# その選び方は簡単でしかも最大や最小の値には決してならないという方法でなければ
# なりません。ランダムに選ぶのは方法としては簡単ですが、すでに見たように必ずし
# も常によい選択になるとは限りません。では全ての項目の値を調べて、そのメジアン
# をとるというのはどうでしょう？この方法は分割値の決め方としては理想的でもしか
# し、ソートそのものよりも多くの時間を要してしまいますから実用的ではありません。
# そこで妥協案として考えられたのが、配列の最初の項目、最後の項目、そして中央の
# 項目の中央の値を分割値とする方法を、３つのメジアンと言います。
# さらに成分が３よりも少ない小さな配列をソートするmanualSort()を実装しています。
# このメソッドは、部分配列が１セル以下なら直ちにリターン、２セルなら必要な入れ
# 替えを行い、３セルならソートをします。３のメジアン法は、配列が４成分以上でな
# いと使えませんから、３成分以下の配列に対しては今回のrecQuickSort()では使えな
# いのです。

pertisionIt2(){
    #最初の成分の右
    local leftPtr=$1  ;
    #分割値の左
    local rightPtr=$(($2-1)) ;
    local pivot=$3
    while :; do
        #より大きい項目を見つける
        while (( array[++leftPtr]<pivot )); do
           : 
        done
        #より小さい項目を見つける
        while (( array[--rightPtr]>pivot )); do
           :
        done
        #ポインタが交差したら
        if [ "$leftPtr" -ge "$rightPtr" ]; then
            #分割は終了
            break ;
        else
            #交差していないので成分を入れ替える
            local tmp=${array[leftPtr]} ;
            array[leftPtr]=${array[rightPtr-1]} ;
            array[rightPtr-1]=$tmp ;
        fi
    done
    #分割値をリストア
    local tmp="${array[leftPtr]}" ;
    array[leftPtr]="${array[right-1]}" ;
    array[right-1]="$tmp" ;

    #分割値の位置を返す
    pertision="$leftPtr" ;
}
manualSort2(){
    local left="$1" ;
    local right="$2" ;
    local size=$((right-left+1)) ; 
    if [ "$size" -le 1 ]; then
        #ソート不要
        return ;
    fi
    if [ "$size" -eq 2 ]; then
        #２のソート leftとrightを入れ替える
        if [ "${array[left]}" -gt "${array[right]}" ]; then 
            local tmp="${array[left]}" ;
            array[left]="${array[right]}" ;
            array[right]="$tmp" ;
            return ;
        fi
    else
    #サイズが３
        #３のソート,left, center, (right-1) & right
        if [ "${array[left]}" -gt "${array[right-1]}" ]; then
            # left / center
            local tmp="${array[left]}" ;
            array[left]="${array[right-1]}" ;
            array[right-1]="$tmp" ;
        fi
        # left / right
        if [ "${array[left]}" -gt "${array[right]}" ]; then
            local tmp="${array[left]}" ;
            array[left]="${array[right]}" ;
            array[right]="$tmp" ;
        fi
        # center / right
        if [ "${array[right-1]}" -gt "${array[right]}" ]; then
            local tmp="${array[right-1]}" ;
            array[right-1]="${array[right]}" ;
            array[right]="$tmp" ;
        fi
    fi
}
medianOf3_2(){
    local left=$1 ;
    local right=$2 ;
    local center=$(( (left+right) / 2 )) ;
    if [ "${array[left]}" -gt "${array[center]}" ]; then
        # left / centerを正順化
        local tmp="${array[left]}" ;
        array[left]="${array[center]}" ;
        array[center]="$tmp" ;
    fi
    if [ "${array[left]}" -gt "${array[right]}" ]; then
        # left / rightを正順化
        local tmp="${array[left]}" ;
        array[left]="${array[right]}";
        array[right]="$tmp" ;
    fi
    if [ "${array[center]}" -gt "${array[right]}" ]; then
        # center rightを正順化
        local tmp="${array[center]}" ;
        array[center]="${array[right]}" ;
        array[right]="$tmp" ;
    fi
    # 分割値をrightに
    local tmp="${array[center]}" ;
    array[center]="${array[right-1]}" ;
    array[right-1]="$tmp" ;

    #メジアンの値を返す
    median="${array[right-1]}" ;
}
quickSort2(){
    local left="$1" ;
    local right="$2" ;
    local size=$((right-left+1)) ;
    if [ "$size" -le 3 ]; then
        #小さければマニュアルソート
        manualSort2 "$left" "$right" ;
    else
        medianOf3_2 "$left" "$right" ;
        #範囲を分割する 戻り値は $pertision 
        pertisionIt2 "$left" "$right" "$median";
        #左側をソート
        quickSort2 "$left" "$((pertision-1))"  ;
        #右側をソート
        quickSort2 "$((pertision+1))" "$right" ; 
    fi
}

########################################
# 普通のクイックソート
########################################
#
function pertisionIt1(){
    #最初の成分の右
    local leftPtr=$(($1-1))  ;
    #分割値の左
    local rightPtr="$right" ;
    local pivot="$3" ;
    while :; do
        #より大きい項目を見つける
        while ((array[++leftPtr]<pivot)); do
           : 
        done
        #より小さい項目を見つける
        while ((rightPtr>0 &&  array[--rightPtr]>pivot)); do
           :
        done
        #ポインタが交差したら
        if [ "$leftPtr" -ge "$rightPtr" ]; then
            #分割は終了
            break ;
        else
            #交差していないので成分を入れ替える
            local tmp="${array[leftPtr]}" ;
            array[leftPtr]="${array[rightPtr]}" ;
            array[rightPtr]="$tmp" ;
        fi
    done
    #分割値をリストア
    local tmp="${array[leftPtr]}" ;
    array[leftPtr]="${array[right]}" ;
    array[right]="$tmp" ;

    #分割値の位置を返す
    pertision="$leftPtr" ;
}
function quickSort1(){
    local left="$1" ;
    local right="$2" ;
    local size=$((right-left)) ;
    if [ "$size" -le 0 ]; then 
     : 
    else
        #範囲を分割する 戻り値は $pertision 
        pertisionIt1 "$left" "$right" "${array[right]}";
        #左側をソート
        quickSort1 "$left" "$((pertision-1))"  ;
        #右側をソート
        quickSort1 "$((pertision+1))" "$right" ; 
    fi
}

quickSort3(){
    setArray "$1" ;
    display ;
    recQuickSort 0 $(($nElems-1));
    display ;
}
quickSort2(){
    setArray "$1" ;
    display ;
    recQuickSort2 0 $(($nElems-1));
    display ;
}
quickSort1(){
    setArray "$1" ;
    display ;
    recQuickSort1 0 $(($nElems-1));
    display ;
}

#
time quickSort1 100 ;
time quickSort2 100 ;
time quickSort3 100 ;
exit ;
#
