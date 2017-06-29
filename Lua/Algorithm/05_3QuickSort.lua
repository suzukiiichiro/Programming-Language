#!/usr/bin/env luajit

--[[ #
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
]]--
Array={}; Array.new=function()
  local this={
    ar={};
    nElems=0;
  };

  function Array:execArray(num)
    self:setArray(num);
    self:display();
	  self:quickSort(1,#self.ar)
    self:display();
  end

  function Array:setArray(num)
    for i=1,num,1 do
      self:insert(math.random(1000));
    end
  end

  function Array:insert(r)
    self.nElems=self.nElems+1;
    self.ar[self.nElems]=r;
  end

  function Array:display()
    for i=1,self.nElems,1 do
      print(i..":"..self.ar[i]);
    end
  end

  function Array:partition(low, high)
    local low = low
    local high = high
    local pivotKey = self.ar[low] 
    while low < high do
        while low < high and self.ar[high] >= pivotKey do
            high = high - 1
        end
        self.ar[low], self.ar[high] = self.ar[high], self.ar[low]
        while low < high and self.ar[low] <= pivotKey do
            low = low + 1
        end
        self.ar[low], self.ar[high] = self.ar[high], self.ar[low]
    end
    return low
  end

  function Array:quickSort(low, high)
    local low=low;
    local high=high;
    if low < high then
        local pivotKeyIndex = self:partition(low, high)
        self:quickSort(low, pivotKeyIndex - 1)
        self:quickSort(pivotKeyIndex + 1, high)
    end
  end
  return setmetatable(this, {__index=Array});
end

s = os.clock();
Array.new():execArray(1000);
print(os.clock()-s);

