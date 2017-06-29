#!/usr/bin/env luajit

--[[
################
# 00 配列
# 配列はデータ構造の一つで、複数の値を格納する事が出来ます。
# 各要素には添え字（データの何番目かを表す数字）でアクセスできます。
# データはメモリーの連続した領域に、順番通りに格納されます。
# 連続した領域に格納されているので、メモリアドレスが添え字を使って計算でき、各
# データにランダムアクセスが出来ます。# また、配列の特徴として、任意の場所へのデー
# タの追加・削除の操作がリストに比べてコストが高いです。
# 
# a[0]   a[1]   a[2]
# blue   yellow red
#
# green
#
# greenを２番目に追加する事を考えます。
# まず配列の最後に追加する空間を確保します。
# 
# a[0]   a[1]   a[2]  a[3]
# blue   yellow red   
#
# 追加される空間を空けるため、一つずつデータをずらします。
# 
# a[0]   a[1]   a[2]  a[3]
# blue   yellow       red   
#
#        ↓
# a[0]   a[1]   a[2]   a[3]
# blue          yellow red   
#
#        ↓
# 空いた空間にgreenを追加して追加の操作が完了します。
#
# a[0]   a[1]   a[2]   a[3]
# blue   green  yellow red   
#
# 逆に２番目の要素を削除するときは、
# まず２番目の要素を削除し、
#
# a[0]   a[1]   a[2]   a[3]
# blue          yellow red   
#
#        ↓
# 空いた空間にデータを一つずらして埋めます。
# a[0]   a[1]   a[2]   a[3]
# blue   yellow        red   
#
#        ↓
# a[0]   a[1]   a[2]   a[3]
# blue   yellow red   
#
#        ↓
# 最後に余った空間を削除して削除の操作が完了します。
# a[0]   a[1]   a[2]
# blue   yellow red   
#
# こうした追加・削除の操作は以降のソートの処理で学びますので、ここではデータ配
# 列を生成する処理を覚えます。
# 
################
#
--]]
--[[
##
# <> set Array
#
Luaで疑似乱数を発生させるにはmath.random()を使います。何もパラメータを指定しな
い場合は0から1までの乱数を返します。パラメータを1つ指定した場合には1から指定し
た数までの乱数を返します。パラメータが2つの場合は最初のパラメータを最小値、2つ
目のパラメータを最大値とした疑似乱数を返します。 また、疑似乱数の種（シード）を
設定するにはmath.randomseed()を使います。パラメータには疑似乱数の種となる値を指
定します。
--]]

Array={}; Array.new=function()
  local this={
    ar={};
    nElems=0;
  };

  function Array:execArray(num)
    self:setArray(num);
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

  return setmetatable(this,{__index=Array});
end

s = os.clock();
Array.new():execArray(1000);
print(os.clock()-s);

