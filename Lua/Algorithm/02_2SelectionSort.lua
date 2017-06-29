#!/bin/lua

--[[
################
# 選択ソート
################
#
# 選択ソートは数列を整列するアルゴリズムの一つです。
# 数列を線形探索し、最小値を探します。
# 探索した最小値を、ソート済みではない列の左端の数と交換し、ソート済みにします。
# なお、最小値がすでに左端であった場合には、何の操作も行いません。
# 同様の操作を全ての数字にソート済みになるまで繰り返します。
#
# 5   9   3   1   2   8   4   7   6
# min 
# 
#     ↓
# 5   9   3   1   2   8   4   7   6
# min 
# 
#         ↓
# 5   9   3   1   2   8   4   7   6
#        min 
#
#             ↓
# 5   9   3   1   2   8   4   7   6
#            min 
#
#                 ↓
# 5   9   3   1   2   8   4   7   6
#            min 
#
#                     ↓
# 5   9   3   1   2   8   4   7   6
#            min 
#
#                                 ↓
# 5   9   3   1   2   8   4   7   6
#            min 
#
# 一番目の５とminの１を入れ替える
# 1   9   3   5   2   8   4   7   6
#   
#
# minを一つ右へずらす
# 1   9   3   5   2   8   4   7   6
#    min 
#
# 一番左端は配置済みなので探索の必要はない。
# 右へ探索し最小値を探す      
#
#     ↓
# 1   9   3   5   2   8   4   7   6
#    min 
#
#         ↓
# 1   9   3   5   2   8   4   7   6
#        min 
#
#             ↓
# 1   9   3   5   2   8   4   7   6
#        min 
#
#                 ↓
# 1   9   3   5   2   8   4   7   6
# 済             min 
#
# 
# 探索が右端まで到達したらソート済みではない左端の数値のminを交換します。
#                                 ↓
# 1   9   3   5   2   8   4   7   6
# 済             min 
#
#         ↓
# 1   2   3   5   9   8   4   7   6
# 済  済 
#
# 同様の操作を、全ての数字がソート済みになるまで繰り返します。
# 
# 
# 選択ソート
#https://www.youtube.com/watch?v=f8hXR_Hvybo
#　平均計算時間が O(ｎ^2)
#　安定ソートではない
#　比較回数は「　n(n-1)/2　」
#　交換回数は「　n-1　」
#
# 外側outは右側端nElems-1から左へ移動
# 内側 inは左側0から右へinを移動。
# maxよりinが大きかったらinの値をmaxへ
# ターン終了後にoutとmaxを[必ず]入れ替え
# 一番右側列からソート済み
#
# bubbleSort 比較 O(N2乗) 入れ替え O(N2乗) 
# selectSort 比較 O(N2乗) 入れ替え O(N) 
# 入れ替え回数が少ない分bubbleSortよりも高速
# 入れ替えに要する時間が比較の時間より相当大きい時にはその差も大きい
#
]]--
--

Array={}; Array.new=function()
  local this={
    ar={};
    nElems=0;
  };

  function Array:execArray(num)
    self:setArray(num);
    --self:display();
    --self:bubbleSort();
		self:selectionSort();
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

  function this:selectionSort()
    -- m:min
    for i=1,self.nElems,1 do
      local m=i;
      for j=i+1,self.nElems,1 do
        if self.ar[m]>self.ar[j] then
          m=j;
        end
      end
      self.ar[m],self.ar[i]=self.ar[i], self.ar[m];
    end
  end
  return setmetatable(this,{__index=Array});
end

s = os.clock();
Array.new():execArray(1000);
print(os.clock()-s);


