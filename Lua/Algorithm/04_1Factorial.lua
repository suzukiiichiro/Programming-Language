#!/bin/lua

--[[#
####################
# 再帰-階乗値
####################
#
# 3人の順序の種類は
# 3 * 2 * 1 で求められる = 6通り
#
# 5人の順序の種類は
# 5 * 4 * 3 * 2 * 1 で求められる = 120通り
#
# 5の階乗は 5! と表現する
#
# 10の階乗を求める場合 
# 10! = 10 * 9 * 8 * 7 * 6 * 5 * 4 * 3 * 1 = ?
#
# 階乗を求めるメソッドfactorialは、行うべき処理を実現するために、
# メソッドfactorialを呼び出します。このようなメソッド呼び出しを再帰呼び出しと言います。
# 
##
#]]--
Factorial={}; Factorial.new=function()
  local this={};
  function Factorial:Factorial(n)
    if n==1 then
      return 1;
    else
      return n * self:Factorial(n - 1);
    end
  end
  return setmetatable(this,{__index=Factorial});
end

s=os.clock();
print(Factorial.new():Factorial(10));
print(os.clock()-s);
