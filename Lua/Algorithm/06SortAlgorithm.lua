#!/usr/bin/env luajit

--[[ ##
 # Bash(シェルスクリプト)で学ぶアルゴリズムとデータ構造  
 # 一般社団法人  共同通信社  情報技術局  鈴木  維一郎(suzuki.iichiro@kyodonews.jp)
 #
 # ステップバイステップでアルゴリズムを学ぶ
 # 
 # 目次
 # ソートアルゴリズム
 #   バブルソート
 #   挿入ソート
 #   選択ソート
 #   マージソート
 #   シェルソート
 #   クイックソート
]]--

-- 共通部分 

--[[ ##
 # 1. バブルソート 13404mm
 # https://ja.wikipedia.org/wiki/バブルソート
 # https://www.youtube.com/watch?v=8Kp-8OGwphY
 #   平均計算時間が O(N^2)
 #   安定ソート
 #   比較回数は「  n(n-1)/2  」
 #   交換回数は「  n^2/2  」
 #   派生系としてシェーカーソートやコムソート
## ]]--


--[[##
 # 挿入ソート 3511mm
 # https://ja.wikipedia.org/wiki/挿入ソート
 # https://www.youtube.com/watch?v=DFG-XuyPYUQ
 #   平均計算時間が O(N^2)
 #   安定ソート
 #   比較回数は「  n(n-1)/2以下  」
 #   交換回数は「  約n^2/2以下  」
## ]]--


--[[##
 # 選択ソート 3294mm
 # https://ja.wikipedia.org/wiki/選択ソート
 # https://www.youtube.com/watch?v=f8hXR_Hvybo
 #   平均計算時間が O(N^2)
 #   安定ソートではない
 #   比較回数は「  n(n-1)/2  」
 #   交換回数は「  n-1  」
##]]--


--[[##
 # マージソート 1085mm
 # https://ja.wikipedia.org/wiki/マージソート
 # https://www.youtube.com/watch?v=EeQ8pwjQxTM
 #   平均計算時間が O(N(Log N))
 #   安定ソート
 #   50以下は挿入ソート、5万以下はマージソート、あとはクイックソートがおすすめ。
 #   バブルソート、挿入ソート、選択ソートがO(N^2)の時間を要するのに対し、マージ
 #   ソートはO(N*logN)です。
 #   例えば、N(ソートする項目の数）が10,000ですと、N^2は100,000,000ですが、
 #   n*logNは40,000です。別の言い方をすると、マージソートで４０秒を要するソート
 #   は、挿入ソートでは約２８時間かかります。
 #   マージソートの欠点は、ソートする配列と同サイズの配列をもう一つ必要とする事
 #   です。
 #   元の配列がかろうじてメモリに治まるという大きさだったら、マージソートは使え
 #   ません。
##]]--


--[[##
 # シェルソート 1052mm
 # https://ja.wikipedia.org/wiki/シェルソート
 # https://www.youtube.com/watch?v=M9YCh-ZeC7Y
 #   平均計算時間が O(N((log N)/(log log N))^2)
 #   安定ソートではない
 #   挿入ソート改造版
 #   ３倍して１を足すという処理を要素を越えるまで行う
##]]--


--[[##
 # クイックソート 1131mm
 # https://ja.wikipedia.org/wiki/クイックソート
 # https://www.youtube.com/watch?v=aQiWF4E8flQ
 #   平均計算時間が O(n Log n)
 #   安定ソートではない
 #   最大計算時間が O(n^2)
 # データ数が 50 以下なら挿入ソート (Insertion Sort)
 # データ数が 5 万以下ならマージソート (Merge Sort)
 # データ数がそれより多いならクイックソート (Quick Sort)
##]]--



Sort={}; Sort.new=function()
  local this={
    ar={};
    nElems=0;
  };

  function Sort:execArray()
    self:bs();
    self:is();
    self:ss();
    self:ms();
    self:shs();
    self:qs();
  end

  function Sort:setArray(num)
    for i=1,num,1 do
      self:insert(math.random(1000));
    end
  end
  
  function Sort:insert(r)
    self.nElems=self.nElems+1;
    self.ar[self.nElems]=r;
  end

  function Sort:display()
    for i=1,self.nElems,1 do
      print(i..":"..self.ar[i]);
    end
  end

  function Sort:bs()
    self.nElems=0; self.ar={};
    local s=os.clock(); self:setArray(10000); self:bubbleSort(); local e=os.clock(); print("bubbleSort"..":"..e-s);
  end

  function Sort:is()
    self.nElems=0; self.ar={};
    local s=os.clock(); self:setArray(10000); self:insertionSort(); local e=os.clock(); print("insertionSort"..":"..e-s);
  end

  function Sort:ss()
    self.nElems=0; self.ar={};
    local s=os.clock(); self:setArray(10000); self:selectionSort();local e=os.clock(); print("selectionSort"..":"..e-s);
  end

  function Sort:ms()
    self.nElems=0; self.ar={};
    local s=os.clock(); self:setArray(10000); self:mergeSort(1,self.nElems);local e=os.clock(); print("mergeSort"..":"..e-s);
  end

  function Sort:shs()
    self.nElems=0; self.ar={};
    local s=os.clock(); self:setArray(10000); self:shellsort();local e=os.clock(); print("shellSort"..":"..e-s);
  end

  function Sort:qs()
    self.nElems=0; self.ar={};
    local s=os.clock(); self:setArray(10000); self:quickSort(1, #self.ar); local e=os.clock(); print("quickSort"..":"..e-s);
  end

  function Sort:bubbleSort()
    for i=self.nElems,1,-1 do
      for j=1,i-1,1 do
        if self.ar[j]>self.ar[j+1] then
            self.ar[j],self.ar[j+1]=self.ar[j+1],self.ar[j];
        end
      end
    end
  end

  function Sort:selectionSort()
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

  function Sort:insertionSort()
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

  function Sort:mergeSort(low,high)
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

  function Sort:shellsort()
    local inc = math.ceil(#self.ar/2)
    while inc>0 do
        local i;
        local tmp;
        for i=inc, #self.ar do
            local tmp=self.ar[i]
            local j=i
            while j>inc and self.ar[j-inc]>tmp do
                self.ar[j] = self.ar[j-inc]
                j=j-inc
            end
            self.ar[j]=tmp
        end
        inc=math.floor(0.5+inc/2.2 )
    end
  end

  function Sort:partition(low, high)
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

  function Sort:quickSort(low, high)
    local low=low;
    local high=high;
    if low < high then
        local pivotKeyIndex = self:partition(low, high)
        self:quickSort(low, pivotKeyIndex - 1)
        self:quickSort(pivotKeyIndex + 1, high)
    end
  end
  
  return Sort;
end
Sort.new():execArray();
