#!/bin/lua

--[[#########
# Circular Queue
# 映画館の待ち行列なら、先頭の一人が列を去ったら、列全体が前に進みます。
# キューでも、削除のたびに全ての項目を移動する事は出来ますが、しかしその時間が無駄です。
# むしろ項目はそのままにしておいて、キューの前端や後端が動いた方が簡単なのです。
# しかしその場合の問題は、キューの後端がすぐに配列の終端に達してしまいます。
# まだ満杯ではないのに新たなデータを挿入できないというこの問題を解決するために、
# キューのfrontとrear矢印は配列の先頭へラップアラウンド（最初に戻る）します。
# その結果として円環キューというものができあがります。リングバッファとも呼ばれます。
]]--
CQueue={};
CQueue.new=function()
  local this={
    nElems=1;
    ar={};
    rear=0; --[[#後ろ端（enqueueされるほう）]]--
    front=1; --[[#前端（peek/dequeueされるほう)]]--
    maxSize=5; --[[#キューの項目数]]--
    queue ={};
  };

  function CQueue:display()
    for i=1,self.nElems,1 do
      print(i..":"..self.ar[i]);
    end
  end

  function CQueue:insert(r)
    self.nElems=self.nElems+1;
    self.ar[self.nElems]=r;
  end
  
  function CQueue:setArray(num)
    for i=1,num,1 do
      self:insert(math.random(10));
    end
  end

  function CQueue:CircularQDisplay()
    --for i=1,maxSize-1,1 do
    for i=1,self.maxSize,1 do
      print(i.." "..self.queue[i]);
    end
    print("------");
  end

  function CQueue:CircularQDequeue()
    self.front=self.front+1;
    if self.front==self.maxSize then
      self.front=1;
    end
  end
  
  function CQueue:CircularQEnqueue(q)
    if self.rear==self.maxSize then
      self.rear=0;
    end
    self.rear=self.rear+1;
    self.queue[self.rear]=q;
  end

  function CQueue:CircularQPeek()
    print("peek :front :"..self.front.."  rear : "..self.rear.."  peek : "..self.front.." "..self.queue[self.front]);
  end

  function CQueue:initQueue()
    for i=1,self.maxSize,1 do
      self.queue[i]=0;
    end
  end

  function CQueue:execCircularQ()
    self:initQueue() ;
    self:CircularQEnqueue(10);
    self:CircularQEnqueue(20);
    self:CircularQEnqueue(30);
    self:CircularQEnqueue(40);
    print("データを4つenqueue");
    self:CircularQPeek();
    self:CircularQDisplay();
    --[[#----]]--
    self:CircularQDequeue();
    self:CircularQDequeue();
    print("データを2つdequeue");
    self:CircularQPeek();
    self:CircularQDisplay();
    --[[#----]]--
    self:CircularQEnqueue(50);
    print("データを1つenqueue");
    self:CircularQPeek();
    self:CircularQDisplay();
    --[[# CircularQ]]--
    self:CircularQEnqueue(60);
    self:CircularQEnqueue(70);
    print("データを2つenqueue");
    self:CircularQPeek();
    self:CircularQDisplay();
    self:CircularQDequeue();
    self:CircularQDequeue();
    self:CircularQDequeue();
    print("データを3つdequeue");
    self:CircularQPeek();
    self:CircularQDisplay();
  end
  return setmetatable(this,{__index=CQueue});
end

s=os.clock();
CQueue.new():execCircularQ();
print(os.clock()-s);

