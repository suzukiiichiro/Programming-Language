#!/bin/lua

--[[
#########
# Queue
# 
# キューはデータ構造の一つです。
# キューは待ち行列とも呼ばれ、その名の通り行列に並ぶ事を考えるとイメージしやすいです。
# 行列においては、先に並んだ人ほど優先されます。 
# キューにデータを追加する場合、データは一番最後に追加されます。
# キューにデータを追加する操作をenqueueと呼びます。
# キューからデータを取り出す場合、最も古くに追加されたデータから取り出されます。
# キューからデータを取り出す操作をdequeueと呼びます。
# このような、先に入れたものを先に出す先入れ先出しの仕組みを
# 「First In First Out」を略してFIFOと呼びます。
# 
#########
#
##
#
]]--
Queue={}; Queue.new=function()
  local this={
    nElems=0;
    ar={};
    queue ={};
    rear=0;   --[[#後ろ端（enqueueされるほう）]]--
    front=1;  --[[#前端（peek/dequeueされるほう)]]--
  };

  function Queue:display()
    for i = 1,self.nElems,1 do
      print(i..":"..self.ar[i]);
    end
  end

  function Queue:insert(r)
    self.nElems=self.nElems+1;
    self.ar[self.nElems]=r;
  end

  function Queue:setArray(num)
    for i=1,num,1 do
      self:insert(math.random(10000));
    end
  end
  
  function Queue:queueDisplay()
    for i=self.front,self.rear,1 do
      print(i..":"..self.queue[i]);
    end
    print("------");
  end

  function Queue:dequeue()
    self.front=self.front+1;
  end

  function Queue:enqueue(q)
    self.rear=self.rear+1;
    self.queue[self.rear]=q;
  end

  function Queue:peek()
    print("peek :"..self.front..":"..self.queue[self.front]);
  end

  function Queue:execQueue()
    self:enqueue(10);
    self:enqueue(20);
    self:enqueue(30);
    self:enqueue(40);
    print("データを4つenqueue");
    self:peek();
    self:queueDisplay();
    --[[#----]]--
    self:dequeue();
    self:dequeue();
    print("データを2つdequeue");
    self:peek();
    self:queueDisplay();
    --[[#----]]--
    self:enqueue(50);
    print("データを1つenqueue");
    self:peek();
    self:queueDisplay();
    --[[#----]]--
  end
  return setmetatable(this,{__index=Queue});
end

s=os.clock();
Queue.new():execQueue();
print(os.clock()-s);
