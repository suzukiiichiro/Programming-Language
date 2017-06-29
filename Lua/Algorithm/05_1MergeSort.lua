#!/usr/bin/env luajit

--[[#
################
# マージソート
# 
# マージソートは数字列を整列するアルゴリズムの１つです。
# 
# 6   4   3   7   5   1   2
#
# 始めに数列を半分ずつに分割していきます。
#
# 6   4   3   7    |  5   1   2
#
#         ↓               ↓
# 6   4  |  3   7  |  5   1  |  2
#
#         ↓               ↓
#  6 | 4 |  3 | 7  |  5 | 1  |  2
#
# 分割が完了したら、分割して出来高くグループを合体していきます。
# 合体するときは、合体後のグループ内で数字が小さい順に並ぶように小さい数字から順に移動します。
# 
#  6 | 4 |  3 | 7  |  5 | 1  |  2
#    ↓        ↓        
#  4   6 |  3   7  |  5   1  |  2
#
# 複数の数字を含むグループを合体する場合、先頭の数を比較し、小さい方の数を移動します。
#
#  4   6 |  3   7  |  5   1  |  2
#
# この場合は、４と３を比較します。同容易残った列の先頭の数を比較し、4<7なので4を移動します。
#
#  4   6 |  3   7  |  5   1  |  2
#    ↓        ↓
#  3   4           |  5   1  |  2
#
# 6<7なので6を移動します。
#
#  3   4    6      |  5   1  |  2
#
# 残った７を移動します。
#
#  3   4    6   7  |  5   1  |  2
#
# グループの合体の操作は、全ての数が１つのグループになるまで再帰的に繰り返します。
#
#  3   4    6   7  |  5   1  |  2
#                       ↓       ↓
#  3   4    6   7  |  1   5  |  2
#                       ↓       ↓
#  3   4    6   7  |  1   2     5
#                ↓
#  1   2    3   4     5   6     7
#
# 合体が完了し、数列がソートされました。
#
#
# バブルソート、挿入ソート、選択ソートがO(N^2)の時間を要するのに対し、
# マージソートはO(N*logN)です。
# 例えば、N(ソートする項目の数）が10,000ですと、N^2は100,000,000ですが、
# n*logNは40,000です。別の言い方をすると、マージソートで４０秒を要するソートは、
# 挿入ソートでは約２８時間かかります。
# マージソートの欠点は、ソートする配列と同サイズの配列をもう一つ必要とする事です。
# 元の配列がかろうじてメモリに治まるという大きさだったら、マージソートは使えません。
# 
################
#
#  https://www.youtube.com/watch?v=EeQ8pwjQxTM
#　平均計算時間が O(n Log n)
#　安定ソートです。
#
# コメント
# 50以下挿入ソート、5万以下マージソート、あとはクイックソート
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
    --self:insertionSort();
	  self:mergeSort(1,self.nElems)
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

  function Array:bubbleSort()
    for i=self.nElems,1,-1 do
      for j=1,i-1,1 do
        if self.ar[j]>self.ar[j+1] then
            self.ar[j],self.ar[j+1]=self.ar[j+1],self.ar[j];
        end
      end
    end
  end

  function Array:selectionSort()
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

  function Array:mergeSort(low,high)
    local low=low;
    local high=high;
    if high-low<1 then return end
    local mid=math.floor((low+high)/2)
    self:mergeSort(low,mid)
    self:mergeSort(mid+1,high)
    local i,m=low,mid;
    local temp;
    while i<=m and m+1<=high do
      if self.ar[i]>=self.ar[m+1] then
        temp=self.ar[m+1]
        for j=m,i,-1 do
            self.ar[j+1]=self.ar[j]
        end
          self.ar[i]=temp;
          m=m+1;
      else
          i=i+1;
      end
    end
  end
  return setmetatable(this,{__index=Array});
end

s = os.clock();
Array.new():execArray(1000);
print(os.clock()-s);

