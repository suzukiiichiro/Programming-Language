#!/usr/bin/env luajit

--[[
#################
# Shell Sort
#################
#
# シェルソートは挿入ソートの改良版です。
# 挿入ソートの途中では、マーカーの左側の項目は内部的に（それらだけの間で）ソートされていて、
# マーカーの右側はまだ手つかずです。
# アルゴリズムは、マーカーの項目を取り去り、それを一時変数に保存します。
# 次に、そうやって空になったセルの左隣から、
# ソート済みの項目を次々と右へシフトしていき（つまり空のセルを次々と左へ移動して）、
# 一時変数に保存した項目が正しく納められる場所を作り出します。
# しかし、この点に挿入ソートの問題があります。
# 仮に最大の項目がおさまるべき最も右端に小さな項目があったらどうなるでしょうか？
# その小さな項目を、左側の正しい場所に納めるためには、
# それより大きい全ての項目をいちいち右へシフトしなければなりません。
# これは、極端な場合にはほとんどＮ回のコピーになります。
# たった１個の項目のためにＮ回ですよ。
# もちろん全ての項目がＮ回のコピーを必要とするわけではありませんから、
# 平均すると１項目につきN/2回のコピー、それに項目数Ｎをかけますと、N^2/2回のコピーとなります。
# 従って挿入ソートの実効性能はＯ（Ｎ＾２）です。
# 
# 小さな項目を左へ移すとき、挿入ソートのようにその間の項目を全て右へシフトするのではなくて、
# その小さな項目だけを一挙に左に移す方法があれば、
# ソートの実効性能はかなり良くなるのではないでしょうか。
# 
# シェルソートは大きな歩幅で飛び飛びに「挿入ソート」をすることによって、このような一挙移動を実現します。
# 大きな歩幅によるソートが終わったら、今度はその最初の歩幅の間に並んでいる項目を、より狭い歩幅でソートが出来ます。
# 配列を歩幅４でソートしたら、今度はそれを歩幅１でソートします。
# つまり通常の挿入ソートをします。
# この歩幅４と歩幅１の組み合わせは、最初から歩幅１だけでソートを行う通常の挿入ソートに比べると相当に早いのです。
#
# 歩幅は伝統的にhで表しインターバル数列といいます。
# アルゴリズムの大家Knuthは最良のインターバル数列を求める公式は以下の通りです。
#
# h=(h-1)/3
#
# 
#
#<> Shell Sort
#シェルソート
#https://www.youtube.com/watch?v=M9YCh-ZeC7Y
#　平均計算時間が O(ｎ^1.25)
#　安定ソートではない
#　挿入ソート改造版
#　３倍して１を足すという処理を要素を超えるまで行う
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
	  self:shellsort()
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

  function Array:shellsort()
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
  return setmetatable(this, {__index=Array});
end

s = os.clock();
Array.new():execArray(1000);
print(os.clock()-s);

