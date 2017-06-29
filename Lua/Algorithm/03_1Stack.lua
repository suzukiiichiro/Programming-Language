#!/bin/lua
--[[ #####
# stack (push/pop)
#
# スタックはデータ構造の一つです。
# スタックの仕組みは、ものを縦に積み上げる事を考えるとイメージしやすいです。
# 積み上げられた山からものを取り出す場合、上から順番に取り出す事になります。
# スタックにデータを追加する場合、データは一番最後に追加されます。
# スタックにデータを追加する操作をpushと呼びます。
# スタックからデータを取り出す場合、最も新しく追加されたデータから取り出されます。
# スタックからデータを取り出す操作をpopと呼びます。
# このような、後から入れたものを先に出す「後入れ先出し」の仕組みを
# 「Last In First Out 」を略してLIFOと呼びます。
# 
##### ]]--
Stack={}; Stack.new=function()
  local this={
    nElems=0;
    ar ={};
  };

  function Stack:display()
    for i=1,self.nElems,1 do
      print(i..":"..self.ar[i]);
    end
  end

  function Stack:insert(r)
    self.nElems=self.nElems+1;
    self.ar[self.nElems]=r;
  end

  function Stack:setar(num)
    for i=1,num,1 do
      self:insert(math.random(10));
    end
  end

  function Stack:stackPeek(s)
    print(s..":"..self.nElems..":"..self.ar[self.nElems]);
  end

  function Stack:stackPush()
    self.nElems=self.nElems+1;
    self.ar[self.nElems]=math.random(10);
    self:stackPeek("push");
  end

  function Stack:stackPop()
    if self.nElems==1 then
      print("Stack is empty");
    else
      self.nElems=self.nElems-1;
      self:stackPeek("pop");
    end
  end

  function Stack:stack()
    self:display();
    self:stackPop();
    self:stackPush();
    self:stackPush();
    self:display();
    self:stackPop();
    self:stackPop();
    self:stackPop();
    self:stackPop();
    self:display();
    self:stackPop();
    self:stackPop();
    self:stackPop();
    self:display(); 
    self:stackPop();
    self:stackPop();
    self:stackPop();
    self:display(); 
    self:stackPop();
  end

  function Stack:execStack(num)
   self:setar(num);
   self:stack();
  end
  return setmetatable(this,{__index=Stack});
end

s=os.clock();
Stack.new():execStack(10);
print(os.clock()-s);

