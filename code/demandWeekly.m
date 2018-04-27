function y=demandWeekly(n)
N=n;
for i=1:N
 x=rand;
if x<=0.04
  demand(1,i)=0;
elseif 0.04<x&x<=0.12
  demand(1,i)=1;
elseif 0.12<x&x<=0.4
  demand(1,i)=2;
elseif 0.4<x&x<=0.8
  demand(1,i)=3;
elseif 0.8<x&x<=0.96
  demand(1,i)=4;
elseif 0.96<x&x<=0.98
  demand(1,i)=5;
elseif 0.98<x&x<=1
  demand(1,i)=6;
else
    demand(1,i)=9;
end
end
y=demand;
end
