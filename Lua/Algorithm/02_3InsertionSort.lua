#!/usr/bin/env luajit

--[[
################
# 挿入ソート
################
#
# 挿入ソートは数列を整列するアルゴリズムの一つです。
# 最初に、左端の数字を操作済みにします。
#
# 済
# 5   3   4   7   2   8   6   9   1
# 
# つづいてまだ操作していないものの中で左端の数字を取り出し、
# 左端の操作済みになっている数字と比較します。
# もし左の数字のほうが大きい場合、二つの数字を入れ替えます。
#
# 済  ↓
# 5   3   4   7   2   8   6   9   1
# 
# この操作を自分より小さい数字が現れるか、数字が左端に到達するまで繰り返します。
# この場合、５＜３なので数字を入れ替えます。
#  ←→
# 3   5   4   7   2   8   6   9   1
# 
# 数字が左端に到達したので止まり、数字を操作済みにします。
#
# 済　済
# 3   5   4   7   2   8   6   9   1
# 
# 同様に左端の数字を取り出し
#
# 済　済  ↓
# 3   5   4   7   2   8   6   9   1
#
# 左の数字と比較します。 
# 済　済  ↓
# 3   5   4   7   2   8   6   9   1
#
# 5 < 4 なので数字を入れ替えます。
#
# 済　↓   済
# 3   4   5   7   2   8   6   9   1
#
# ３＜４でじぶんより小さい数字が現れたので交換せずに止まり、
# 数字を交換済みとして、比較を右に一つ移動します。
#
# 済　済  済  ↓
# 3   4   5   7   2   8   6   9   1
#
# 同様の操作を、全ての数字が操作済みになるまで繰り返します。
#
# 済　済  済  済  ↓
# 3   4   5   7   2   8   6   9   1
#
# 済　済  済  済  済  ↓
# 2   3   4   5   7   8   6   9   1
#
# 済　済  済  済  済  済  ↓
# 2   3   4   5   7   8   6   9   1
#
# 済　済  済  済  済  済  済  ↓
# 2   3   4   5   6   7   8   9   1
#
# 済　済  済  済  済  済  済  済  ↓
# 2   3   4   5   6   7   8   9   1
#
# 済　済  済  済  済  済  済  済  済
# 1   2   3   4   5   6   7   8   9
#
#
#<> insertion Sort
#挿入ソート
#https://www.youtube.com/watch?v=DFG-XuyPYUQ
#　平均計算時間が O(ｎ^2)
#　安定ソート
#　比較回数は「　n(n-1)/2以下　」
#　交換回数は「　約n^2/2以下　」
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
    --self:bubbleSort();
		--self:selectionSort();
    self:insertionSort();
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

  function Array:insertionSort()
    out=2;
    while out<=self.nElems do
      tmp=self.ar[out];
      inp=out;
      while inp>1 and self.ar[inp-1]>=tmp do
        self.ar[inp]=self.ar[inp-1];
        inp=inp-1;
      end
      self.ar[inp]=tmp;
      out=out+1;
    end 
  end
  return setmetatable(this,{__index=Array});
end

s = os.clock();
Array.new():execArray(1000);
print(os.clock()-s);

